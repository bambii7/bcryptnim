# Package
name          = "bcrypt"
version       = "0.2.1"
author        = "Jason Livesay"
description   = "Wraps the bcrypt (blowfish) library for creating encrypted hashes (useful for passwords)"
license       = "BSD"
# installExt    = "c,h"
srcDir        = "./"
bin           = @["bcrypt"]

# Dependencies

requires "nim >= 1.2.0"
