import 'dart:io';
import 'package:meta/meta.dart';
import 'package:AesCrypt/filemanagement.dart';

void aboutAuthor(){
    print("Made By Sunny Paul");
}

class UI{
    String path;
    final key;
    List<String> filelist,dirlist;
    UI(this.key){
        filelist = List();
        dirlist = List();
    }
    
    void takePath() => path = stdin.readLineSync();
    
    void menuEnterData({@required String operation}){
        print("-->enter files/directories");
        print("-->enter q when you are done");
        while(true){
            takePath();
            try{
                if(path.length==1 && path=='q') break;
                else if(FileSystemEntity.isFileSync(path)) {print("this a file"); filelist.add(path);}
                else if(FileSystemEntity.isDirectorySync(path)) dirlist.add(path);   
                else throw Exception('$path not a file or directory');
            }catch(e,s){
                print(e.message);
            }

        }
        switch(operation){
            case 'encrypt':
                if(!filelist.isEmpty)  FileManagement<String>(key: key,doEncryption: true).processFileList(filelist);
                if(!dirlist.isEmpty)  DirectoryManagement(dirList: dirlist,key: key,doEncryption: true).processDirectory(recursive: false);
                break;
            case 'decrypt':
                if(!filelist.isEmpty) FileManagement<String>(key: key,doDecryption: true).processFileList(filelist);
                if(!dirlist.isEmpty) DirectoryManagement(dirList: dirlist,key: key,doDecryption: true).processDirectory(recursive: false);
                break;    
        }
        
    }
    
    void menuDecideOperation(){
            print("1.Encrypt 2.Decrypt");
            var choice = stdin.readLineSync()[0];
            switch(choice){
                case '1':
                    menuEnterData(operation: 'encrypt');
                    break;
                case '2':
                    menuEnterData(operation: 'decrypt');
                    break;
                default:
                    print("not valid choice...");
            }
    }
}

void main(){
    UI userInterface = UI("key");
    aboutAuthor();
    userInterface.menuDecideOperation();
}