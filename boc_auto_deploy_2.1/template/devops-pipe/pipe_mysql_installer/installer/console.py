import logging
import re
import sys


class Console(object):
    def __init__(self):
        self.logger = logging.getLogger("installer.console")

    def echo(self, msg):
        print msg
        sys.stdout.flush()
        self.logger.debug(msg)

    def ask_string(self, question, defaultparam='', regex=None, retry=-1, validate=None):
        if validate and not callable(validate):
            raise TypeError('The validate argument should be callable')
        if defaultparam:
            question += "[%s]" % defaultparam
        question += ":"
        retrycount = retry
        while retrycount != 0:
            response = raw_input(question)
            if not response and defaultparam:
                return defaultparam
            if (not regex or re.match(regex, response)) and (not validate or validate(response)):
                return response
            else:
                self.echo("Please input a valid value")
                retrycount -= 1
        raise ValueError(
            "Console.askString() failed: tried %d times but user didn't fill out a value that matches '%s'." % (retry, regex))

    def ask_password(self, question, confirm=True, regex=None, retry=-1, validate=None):
        if validate and not callable(validate):
            raise TypeError('The validate should be a cllable.')
        response = ""
        import getpass
        if question.endswith(':'):
            question = question[:-2]
        startquestion = question
        question += ": "
        value = None
        failed = True
        mismatch = False
        retrycount = retry
        while retrycount != 0:
            response = getpass.getpass(question)
            if value is None:
                # first password
                if (not regex or re.match(regex, response)) and (not validate or validate(response)):
                    if not confirm:
                        return response
                    else:
                        failed = False
                        value = response
                        question = "%s (confirm): " % startquestion
                else:
                    failed = True
                    #value = None
                    mismatch = False
            else:
                # confirm password
                if value == response:
                    return response
                else:
                    failed = True
                    mismatch = True
                    #value = None
                    question = "%s:" % startquestion
            if failed:
                if mismatch:
                    self.echo("Passwords do not match")
                else:
                    self.echo("Invalid password.\nPasswords need to be between 8 and 16 characters in length.\nPasswords must contain at least 1 lower case and 1 upper case letter.\nPasswords must contain at least 1 numeric value.")
                retrycount -= 1
        raise Exception("Console.askPassword() failed: tried %s times but user didn't fill out a value that matches '%s'." % (retry, regex))

    def ask_integer(self, question, defaultvalue=None, min=None, max=None, retry=-1, validate=None):
        if validate and not callable(validate):
            raise TypeError("The validate shoud be a callable")
        if min is not None and max is not None:
            question += "(%d-%d)" % (min, max)
        elif min is not None:
            question += "(min. %d)" % min
        elif max is not None:
            question += "(max. %d)" % max

        if defaultvalue is not None:
            question += "[%d]" % defaultvalue

        question += ": "

        retrycount = retry

        while retrycount != 0:
            response = raw_input(question)
            if not response and defaultvalue:
                return defaultvalue
            validInt = True
            try:
                value = int(response)
            except ValueError:
                validInt = False

            if validInt and (min is None or (min and value >= min)) and (max is None or (max and value <= max)) and (not validate or validate(value)):
                return value
            else:
                self.echo("Please enter a valid value")
                retrycount -= 1

        raise ValueError("Console.askInteger() failed: tried %d times but user didn't fill out a value that matches '%s'." % (retry, response))

    def ask_choice(self, choices, descr=None, sort=False):
        if not choices:
            return None
        if len(choices) == 1:
            self.echo("Found exactly one choice: %s" % choices[0])
            return choices[0]
        descr = descr or "\nMake a selection please: "
        if sort:
            choices.sort()

        self.echo(descr)

        nr = 0

        for section in choices:
            nr = nr + 1
            self.echo("   %s: %s" % (nr, section))
        self.echo("")
        result = self.ask_integer("   Select Number", min=1, max=nr)
        return choices[result - 1]

    def ask_yes_no(self, question):
        while True:
            response = raw_input(question + "(y/n):")
            responselower = response.lower()
            if responselower == 'y' or responselower == 'yes':
                return True
            if responselower == 'n' or responselower == 'no':
                return False
            self.echo("Illegal value. Enter 'y' or 'n'")
