{.compile: "bcrypt/arc4random.c".}
{.compile: "bcrypt/blowfish.c".}
{.compile: "bcrypt/crypt-blowfish.c".}
{.pragma: mydll.}

proc encode_salt(salt: cstring, csalt: int8, clen: int16, rounds: int8): cstring {.cdecl, mydll, importc: "encode_salt".}

proc hashSalt*(salt: string, rounds: int8, csalt: int8 = 4, clen: int16 = 16): string =
  let cresult = encode_salt(salt, csalt, clen, rounds)
  return $cresult

proc bcrypt_gensalt(rounds: int8): cstring {.cdecl, mydll, importc: "bcrypt_gensalt".}

proc genSalt*(rounds: int8): string =
  return $(bcrypt_gensalt(rounds))  

proc blowfish(key, salt, encrypted: cstring) : int {.cdecl, mydll, importc: "crypt_blowfish".}

proc hash*(key, salt:string): string = 
  var encrypted = newString(60)
  discard blowfish(key, salt, encrypted.cstring)
  return $encrypted  

proc compare_string(s1, s2: cstring): int {.cdecl, mydll, importc: "compare_string".}

proc compare*(s1, s2: string): bool =
  var ret = compare_string(s1,s2)
  if ret == 0:
    return false
  else:
    return true
    
    
when isMainModule:
  var salt = genSalt(5)
  echo "salt is " & salt
  var password = "testPass01%"
  echo("test password is " & password) 
  var hashed = hash(password, salt)
  echo "bcrypt hashed is **" & hashed & "**"

  var passMatches = "testPass01%"
  var hashed2 = hash(passMatches, salt)
  var same = compare(hashed, hashed2)
  
  if same:
    echo("Hashes match. Correct")
  else:
    echo("Hashes do not match. Incorrect!")

  var passDifferent = "testpass02"
  var hashed3 = hash(passDifferent, salt)
  var same2 = compare(hashed, hashed3)
  
  if same2:
    echo("Hashes for different passwords match. Incorrect!")
  else:
    echo("Hashes for different passwords don't match.  Correct.")

  let saltedString1 = hashSalt("testHash", 10)
  let saltedString2 = hashSalt("testHash", 10)
  let hashedpassword1 = hash(password, saltedString1)
  let hashedpassword2 = hash(password, saltedString2)
  assert compare(hashedpassword1, hashedpassword2)
