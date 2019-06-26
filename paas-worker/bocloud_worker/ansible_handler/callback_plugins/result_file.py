from ansible import constants as C
from ansible.module_utils._text import to_bytes, to_text
from ansible.utils.color import colorize, hostcolor
from ansible.playbook.task_include import TaskInclude
from ansible.plugins.callback.default import CallbackModule
import time
import os
import locale

class ResultCallback(CallbackModule):
    def __init__(self, log_path, action):
        self.columns = 70
        super(ResultCallback, self).__init__()
        self.log_file = log_path
        self.error_info = ""
    @staticmethod
    def _output_encoding():
        encoding = locale.getpreferredencoding()
        if encoding in ('mac-roman',):
            encoding = 'utf-8'
        return encoding
    def send_playbook_result(self, msg):
        if not msg.endswith(u'\n'): msg2 = msg + u'\n'
        else: msg2 = msg
        msg2 = to_bytes(msg2, encoding=self._output_encoding())
        if True:
          msg2 = to_text(msg2, self._output_encoding(), errors='replace')
          with open(self.log_file, 'a+') as logf:
            logf.write(msg2)
            logf.flush()
    def banner(self, msg):
      msg = msg.strip()
      star_len = self.columns - len(msg)
      if star_len <= 3:
        star_len = 3
      stars = u"*" * star_len
      self.send_playbook_result(u"\n%s %s" % (msg, stars))
    def v2_runner_on_ok(self, result, **kwargs):
        delegated_vars = result._result.get('_ansible_delegated_vars', None)

        if self._play.strategy == 'free' and self._last_task_banner != result._task._uuid:
            self._print_task_banner(result._task)

        if isinstance(result._task, TaskInclude):
            return
        elif result._result.get('changed', False):
            if delegated_vars:
                msg = "changed: [%s -> %s]" % (result._host.get_name(), delegated_vars['ansible_host'])
            else:
                msg = "changed: [%s]" % result._host.get_name()
        else:
            if delegated_vars:
                msg = "ok: [%s -> %s]" % (result._host.get_name(), delegated_vars['ansible_host'])
            else:
                msg = "ok: [%s]" % result._host.get_name()

        self._handle_warnings(result._result)

        if result._task.loop and 'results' in result._result:
            self._process_items(result)
        else:
            self._clean_results(result._result, result._task.action)

            if (self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result:
                msg += " => %s" % (self._dump_results(result._result),)
            self.send_playbook_result(msg)

    def v2_runner_on_unreachable(self, result):
        if self._play.strategy == 'free' and self._last_task_banner != result._task._uuid:
            self._print_task_banner(result._task)

        delegated_vars = result._result.get('_ansible_delegated_vars', None)
        if delegated_vars:
            self.send_playbook_result("fatal: [%s -> %s]: UNREACHABLE! => %s" % (result._host.get_name(), delegated_vars['ansible_host'],
                                                                             self._dump_results(result._result)),
                                  color=C.COLOR_UNREACHABLE)
        else:
            self.send_playbook_result("fatal: [%s]: UNREACHABLE! => %s" % (result._host.get_name(), self._dump_results(result._result)))

    def v2_runner_on_failed(self, result, ignore_errors=False):
        delegated_vars = result._result.get('_ansible_delegated_vars', None)
        self._clean_results(result._result, result._task.action)

        if self._play.strategy == 'free' and self._last_task_banner != result._task._uuid:
            self._print_task_banner(result._task)

        self._handle_exception(result._result)
        self._handle_warnings(result._result)

        if result._task.loop and 'results' in result._result:
            self._process_items(result)
        else:
            if delegated_vars:
                self.send_playbook_result("fatal: [%s -> %s]: FAILED! => %s" \
                                          % (result._host.get_name(), delegated_vars['ansible_host'],
                                             self._dump_results(result._result)))
            else:
                self.send_playbook_result("fatal: [%s]: FAILED! => %s" \
                                          % (result._host.get_name(), self._dump_results(result._result)))
        if ignore_errors:
            self.send_playbook_result("...ignoring")
    def v2_runner_on_skipped(self, result):
        if self._plugin_options.get('show_skipped_hosts', C.DISPLAY_SKIPPED_HOSTS):  # fallback on constants for inherited plugins missing docs
            self._clean_results(result._result, result._task.action)

            if self._play.strategy == 'free' and self._last_task_banner != result._task._uuid:
                self._print_task_banner(result._task)

            if result._task.loop and 'results' in result._result:
                self._process_items(result)
            else:
                msg = "skipping: [%s]" % result._host.get_name()
                if (self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result:
                    msg += " => %s" % self._dump_results(result._result)
                self.send_playbook_result(msg)
    def v2_playbook_on_no_hosts_matched(self):
        self.send_playbook_result("skipping: no hosts matched")

    def v2_playbook_on_no_hosts_remaining(self):
        self.banner("NO MORE HOSTS LEFT")

    def v2_playbook_on_task_start(self, task, is_conditional):
        if self._play.strategy != 'free':
            self._print_task_banner(task)

    def _print_task_banner(self, task):
        args = ''
        if not task.no_log and C.DISPLAY_ARGS_TO_STDOUT:
            args = u', '.join(u'%s=%s' % a for a in task.args.items())
            args = u' %s' % args

        self.banner(u"TASK [%s%s]" % (task.get_name().strip(), args))

        self._last_task_banner = task._uuid

    def v2_playbook_on_cleanup_task_start(self, task):
        self.banner("CLEANUP TASK [%s]" % task.get_name().strip())

    def v2_playbook_on_handler_task_start(self, task):
        self.banner("RUNNING HANDLER [%s]" % task.get_name().strip())

    def v2_playbook_on_play_start(self, play):
        name = play.get_name().strip()
        if not name:
            msg = u"PLAY"
        else:
            msg = u"PLAY [%s]" % name
        self._play = play
        self.banner(msg)
    
    def v2_on_file_diff(self, result):
        if result._task.loop and 'results' in result._result:
            for res in result._result['results']:
                if 'diff' in res and res['diff'] and res.get('changed', False):
                    diff = self._get_diff(res['diff'])
                    if diff:
                        self.send_playbook_result(diff)
        elif 'diff' in result._result and result._result['diff'] and result._result.get('changed', False):
            diff = self._get_diff(result._result['diff'])
            if diff:
                self.send_playbook_result(diff)

    def v2_runner_item_on_ok(self, result):
        delegated_vars = result._result.get('_ansible_delegated_vars', None)
        self._clean_results(result._result, result._task.action)
        if isinstance(result._task, TaskInclude):
            return
        elif result._result.get('changed', False):
            msg = 'changed'
            color = C.COLOR_CHANGED
        else:
            msg = 'ok'
            color = C.COLOR_OK

        if delegated_vars:
            msg += ": [%s -> %s]" % (result._host.get_name(), delegated_vars['ansible_host'])
        else:
            msg += ": [%s]" % result._host.get_name()

        msg += " => (item=%s)" % (self._get_item(result._result),)

        if (self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result:
            msg += " => %s" % self._dump_results(result._result)
        self.send_playbook_result(msg)

    def v2_runner_item_on_failed(self, result):
        delegated_vars = result._result.get('_ansible_delegated_vars', None)
        self._clean_results(result._result, result._task.action)
        self._handle_exception(result._result)

        msg = "failed: "
        if delegated_vars:
            msg += "[%s -> %s]" % (result._host.get_name(), delegated_vars['ansible_host'])
        else:
            msg += "[%s]" % (result._host.get_name())

        self._handle_warnings(result._result)
        self.send_playbook_result(msg + " (item=%s) => %s" % (self._get_item(result._result), self._dump_results(result._result)))
        
    def v2_runner_item_on_skipped(self, result):
        if self._plugin_options.get('show_skipped_hosts', C.DISPLAY_SKIPPED_HOSTS):  # fallback on constants for inherited plugins missing docs
            self._clean_results(result._result, result._task.action)
            msg = "skipping: [%s] => (item=%s) " % (result._host.get_name(), self._get_item(result._result))
            if (self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result:
                msg += " => %s" % self._dump_results(result._result)
            self.send_playbook_result(msg)

    def v2_playbook_on_include(self, included_file):
        msg = 'included: %s for %s' % (included_file._filename, ", ".join([h.name for h in included_file._hosts]))
        self.send_playbook_result(msg)

    def v2_playbook_on_stats(self, stats):
        self.banner("PLAY RECAP")

        hosts = sorted(stats.processed.keys())
        for h in hosts:
            t = stats.summarize(h)
            self.send_playbook_result(u"%s : %s %s %s %s" % (
                hostcolor(h, t, False),
                colorize(u'ok', t['ok'], None),
                colorize(u'changed', t['changed'], None),
                colorize(u'unreachable', t['unreachable'], None),
                colorize(u'failed', t['failures'], None))
            )

        self.send_playbook_result("")

        # print custom stats
        if self._plugin_options.get('show_custom_stats', C.SHOW_CUSTOM_STATS) and stats.custom:  # fallback on constants for inherited plugins missing docs
            self.banner("CUSTOM STATS: ")
            # per host
            # TODO: come up with 'pretty format'
            for k in sorted(stats.custom.keys()):
                if k == '_run':
                    continue
                self.send_playbook_result('\t%s: %s' % (k, self._dump_results(stats.custom[k], indent=1).replace('\n', '')))

            # print per run custom stats
            if '_run' in stats.custom:    
              self._display.display("", screen_only=True)
              self.send_playbook_result('\tRUN: %s' % self._dump_results(stats.custom['_run'], indent=1).replace('\n', ''))
            self.send_playbook_result("")
        
    def v2_playbook_on_start(self, playbook):
        if self._display.verbosity > 1:
            from os.path import basename
            self.banner("PLAYBOOK: %s" % basename(playbook._file_name))

    def v2_runner_retry(self, result):
        task_name = result.task_name or result._task
        msg = "FAILED - RETRYING: %s (%d retries left)." % (task_name, result._result['retries'] - result._result['attempts'])
        if (self._display.verbosity > 2 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result:
            msg += "Result was: %s" % self._dump_results(result._result)
        self.send_playbook_result(msg)

    def v2_playbook_on_notify(self, handler, host):
        pass
        
        
        
        