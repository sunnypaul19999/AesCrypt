import 'dart:io';
import 'dart:core';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:meta/meta.dart';

abstract class AES{
    final String key;
    final AesCrypt aesCryptObject; 
    const AES({@required this.key,@required this.aesCryptObject});
}


class EncryptDecrypt extends AES{
    const EncryptDecrypt({String key,AesCrypt aesCryptObject}): super(key: key,aesCryptObject: aesCryptObject);
    
    Future<String> encryptThis(String filepath) async {
        aesCryptObject.setPassword(key);
        try{
            print("encrypting $filepath");
            await aesCryptObject.encryptFile(filepath);
            return Future<String>.value("encrypted $filepath");
        } on AesCryptException catch(e,s){
            print(e.message);
        }
        return Future<String>.value("something went wrong while encrypting $filepath");
    }
    
    
    Future<String> decryptThis(String filepath) async {
        aesCryptObject.setPassword(key);
        try{
            print("decrypting $filepath");
            await aesCryptObject.decryptFile(filepath);
            return Future<String>.value("decrypted $filepath");
        } on AesCryptException catch(e,s){
            print(e.message);//catches exception resulting for DUPLICATE file
        }
        return Future<String>.value("something went wrong while decrypting $filepath");
    }    
}