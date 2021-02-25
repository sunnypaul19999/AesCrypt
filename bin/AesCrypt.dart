import 'dart:io';
import 'package:meta/meta.dart';
import 'package:AesCrypt/filemanagement.dart';

void aboutAuthor(){
    print("Made By Sunny Paul");
}



class UI{
    String path;
    final key;
    UI(this.key);
    
    void takePath(){
        print("Enter Directory OR File location:");
        path = stdin.readLineSync();
    }
    
    void menuEnterData({@required String operation}){
        print("1.Single File/Directory 2.Multiple File/Directory");
        var choice = stdin.readLineSync()[0];
        takePath();
        
        switch(choice){
            case '1': 
                if(FileSystemEntity.isFileSync(path)){
                    print("this is a file");//debug code
                    switch(operation){
                        case 'encrypt':
                            FileManagement(key: key,doEncryption: true).processFile(path);
                            break;
                            
                        case 'decrypt':
                            FileManagement(key: key,doDecryption: true).processFile(path);
                            break;
                    }
                }
                if(FileSystemEntity.isDirectorySync(path)){
                    print("this is a directory");//debug code
                    switch(operation){
                        case 'encrypt':
                        DirectoryMangement.directory(dir: Directory(path),key: key,doEncryption: true).processDirectory();
                        break;
                            
                        case 'decrypt':
                        DirectoryMangement.directory(dir: Directory(path),key: key,doDecryption: true).processDirectory();
                        break;
                    }
                }
                break;
            case '2':
                print('this function is not ready yet!!!');
                break;
            default:
                print("not a valid input..");
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