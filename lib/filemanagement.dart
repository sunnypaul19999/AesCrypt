import 'dart:io';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:AesCrypt/cryptographiclogic.dart';

class FileManagement<V>{
    final doEncryption,doDecryption;
    EncryptDecrypt encryptDecryptOb; //why this field cannot be made final
    
    FileManagement({@required final key,this.doEncryption=false,this.doDecryption=false})
    {
         encryptDecryptOb = EncryptDecrypt(key: key,aesCryptObject: AesCrypt());
    }
        
    void processFileList(final filelist){
        String filepath;
        for(V file in filelist){
            if(file is FileSystemEntity) filepath = "${file.toString().substring(7,file.toString().length-1)}";
            else if(file is String) {filepath=file; print('---$filepath');}
            else throw Exception('not a valid type filemangement can take only types FileSytemEntity or String');
            processFile(filepath);
        } 
    }
    
    void processFile(String filepath){
        if(doEncryption) processFileForEncryption(filepath);
        else if(doDecryption) processFileForDecryption(filepath);
        else throw Exception("no operation is selected to process the file select either encryption or decryption");
    }
    
    void processFileForEncryption(String filepath) async{ 
        await encryptDecryptOb
            .encryptThis(filepath)
            .then((statement)=>print(statement));
        File(filepath).delete();
        print("deleted raw file $filepath");
    }
    
    void processFileForDecryption(String filepath) async{
        await encryptDecryptOb
            .decryptThis(filepath)
            .then((statement)=>print(statement));
        File(filepath).delete();
        print("deleted encrypted file $filepath");
    }
}



class DirectoryManagement<V>{
    final dirList;
    FileManagement filemanagement;
    DirectoryManagement({@required this.dirList,@required String key,bool doEncryption=false,bool doDecryption=false})
    {
        filemanagement = FileManagement<FileSystemEntity>(key: key,doEncryption: doEncryption,doDecryption: doDecryption);
    }

    void processDirectory(){
        for(final dir in dirList)  filemanagement.processFileList(Directory(dir).listSync(recursive: true));
    }
}