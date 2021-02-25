import 'dart:io';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:AesCrypt/cryptographiclogic.dart';

class FileManagement<V>{
    final doEncryption,doDecryption;
    EncryptDecrypt encryptDecryptOb; //why this field cannot be made final
    String filepath;
    
    FileManagement({@required String key,this.doEncryption=false,this.doDecryption=false})
     {
         encryptDecryptOb = EncryptDecrypt(key: key,aesCryptObject: AesCrypt());
     }
    
    bool isFileSync(String check)=> (check[0]=='F')? true : false;
    
    void processFileList(List<V> listOfFiles){
         for(V file in listOfFiles){
             if(isFileSync(file.toString())){
                 if(V is FileSystemEntity) filepath = "${file.toString().substring(7,file.toString().length-1)}";
                 if(V is String) filepath=file.toString();
                 processFile(filepath);
            }
        } 
    }
    
    void processFile(String filepath){
        if(doEncryption) processFileForEncryption(filepath);
        else if(doDecryption) processFileForDecryption(filepath);
        else print("you have to select ANY ONE operation");
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



class DirectoryMangement{
    final Directory dir;
    List<FileSystemEntity> listOfFiles;
    FileManagement<FileSystemEntity> filemanagement;
    DirectoryMangement.directory({@required this.dir,@required String key,bool doEncryption=false,bool doDecryption=false})
    {
        filemanagement = FileManagement<FileSystemEntity>(key: key,doEncryption: doEncryption,doDecryption: doDecryption);
        listOfFiles = dir.listSync(recursive: true);
    }
    
    void processDirectory(){
        filemanagement.processFileList(listOfFiles);
    }
}