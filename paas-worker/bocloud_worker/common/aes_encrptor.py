# !/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2019/1/11 19:16
# @Author  : LKX
# @Site    : www.bocloud.com.cn
# @File    : aes_encrptor.py
# @Software: BoCloud

import base64

from Crypto.Cipher import AES


class AESEncrptor():
    def __init__(self):
        self.key = "BocloudCMPV587!!"
        self.iv = "BeyondCMPV587!!!"
        self.mode = AES.MODE_CBC

    def encrypt(self, str):
        try:
            BS = AES.block_size
            pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
            cipher = AES.new(self.key, self.mode, IV=self.iv)
            msg = cipher.encrypt(pad(str))
            msg = base64.encodestring(msg)
            return msg
        except Exception as e:
            raise Exception("encrypt string {} failed".format(str))

    def decrypt(self, en_str):
        try:
            decryptByts = base64.decodestring(en_str.encode("utf-8"))
            unpad = lambda s: s[0:-ord(s[-1])]
            cipher = AES.new(self.key, self.mode, IV=self.iv)
            msg = cipher.decrypt(decryptByts)
            msg = unpad(msg)
            return msg
        except Exception as e:
            raise Exception("decrypt string {} failed".format(en_str))
