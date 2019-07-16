import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;

Table downloadtableftp(boolean inandroid, String filename,String filetype,String filepathweb,String server, int port, String user, String pass){
  if (inandroid) downloadftpfiles(server, port, user, pass, sketchPath(""),filepathweb, filename + "."+ filetype);
  else downloadftpfiles(server, port, user, pass, sketchPath("") + "data/",filepathweb, filename + "."+ filetype);
  return loadtableandroid(filename, filetype, inandroid);
}
void uploadtableftp(Table table, boolean inandroid,String filename,String filetype, String filepathweb, String server, int port, String user, String pass) {
  savetableandroid(filename,filetype, inandroid, table);
  if (inandroid) uploadftpfiles(server, port, user, pass, sketchPath(""), filepathweb, filename + "." + filetype);
  else uploadftpfiles(server, port, user, pass, sketchPath("")+ "data/", filepathweb, filename + "." + filetype);
}
void downloadftpfiles(String server, int port, String user, String pass, String filepathlocal, String filepathweb, String filename) { 
  FTPClient ftpClient = new FTPClient();
  try {
    ftpClient.connect(server, port);
    ftpClient.login(user, pass);
    ftpClient.enterLocalPassiveMode();
    ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
    String remoteFile2 = filepathweb +filename;
    File downloadFile2 = new File(filepathlocal + filename);
    OutputStream outputStream2 = new BufferedOutputStream(new FileOutputStream(downloadFile2));
    InputStream inputStream = ftpClient.retrieveFileStream(remoteFile2);
    byte[] bytesArray = new byte[4096];
    int bytesRead = -1;
    while ((bytesRead = inputStream.read(bytesArray)) != -1) outputStream2.write(bytesArray, 0, bytesRead);
    boolean success = ftpClient.completePendingCommand();
    if (success) System.out.println("File: " + filename + " from: " +filepathweb +  " downloaded");
    outputStream2.close();
    inputStream.close();
  } 
  catch (IOException ex) {
    System.out.println("Error: " + ex.getMessage());
    ex.printStackTrace();
  } 
  finally {
    try {
      if (ftpClient.isConnected()) {
        ftpClient.logout();
        ftpClient.disconnect();
      }
    } 
    catch (IOException ex) {
      ex.printStackTrace();
    }
  }
}
void uploadftpfiles(String server, int port, String user, String pass, String filepathlocal, String filepathweb, String filename) { 
  FTPClient ftpClient = new FTPClient();
  try {
    ftpClient.connect(server, port);
    ftpClient.login(user, pass);
    ftpClient.enterLocalPassiveMode();
    ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
    File secondLocalFile = new File(filepathlocal+filename);
    String secondRemoteFile = filepathweb + filename;
    InputStream inputStream = new FileInputStream(secondLocalFile);
    System.out.println("Start uploading: " + filename + " from: " + filepathlocal);
    OutputStream outputStream = ftpClient.storeFileStream(secondRemoteFile);
    byte[] bytesIn = new byte[4096];
    int read = 0;
    while ((read = inputStream.read(bytesIn)) != -1) outputStream.write(bytesIn, 0, read);
    inputStream.close();
    outputStream.close();
    boolean completed = ftpClient.completePendingCommand();
    if (completed) System.out.println("File uploaded");
  } 
  catch (IOException ex) {
    System.out.println("Error: " + ex.getMessage());
    ex.printStackTrace();
  } 
  finally {
    try {
      if (ftpClient.isConnected()) {
        ftpClient.logout();
        ftpClient.disconnect();
      }
    } 
    catch (IOException ex) {
      ex.printStackTrace();
    }
  }
}
void ftplogin(String server, int port, String user, String pass) {
  FTPClient ftpClient = new FTPClient();
  try {
    ftpClient.connect(server, port);
    int replyCode = ftpClient.getReplyCode();
    if (!FTPReply.isPositiveCompletion(replyCode)) println("Server failed:" + replyCode);
    boolean success = ftpClient.login(user, pass);
    if (!success) println("Not login");
    else println("Login");
  }
  catch (IOException ex) {
    println("Oops! Something wrong happened");
    ex.printStackTrace();
  }
}


Table loadtableandroid(String filenamed, String filetyped, boolean inandroid) {      ///SAVE LOAD TABLES
  Table tout= new Table();
  String fullname = filenamed + "." + filetyped;
  if (!inandroid) tout = loadTable(fullname, "header");
  if (inandroid) {
    try {                                                                                                          
      tout  =  new  Table(new  File(sketchPath("")+fullname), "header");
    } 
    catch  (Exception  e) {   
      try { 
        tout.save(new  File(sketchPath("")+filenamed), filetyped);
      }
      catch(IOException  iox) {
        println("Failed  to  write  file.");
      }
    }
  }
  return tout;
}
void savetableandroid(String filenamed, String filetyped, boolean inandroid, Table tablein) {
  String fullname = filenamed + "." + filetyped;
  if (!inandroid) {
    saveTable(tablein, "data/" + fullname);
    println("saved");
  }
  if (inandroid) {
    try {        
      tablein.save(new  File(sketchPath("")+fullname), filetyped);
      println("saved");
    }    
    catch(IOException  iox) {        
      println("Failed  to  write  file."  +  iox.getMessage());
    }
  }
}


Table exampletable(){
    Table table = new Table();
  table.addColumn("id");
  table.addColumn("species");
  table.addColumn("name");
  TableRow newRow = table.addRow();
  newRow.setInt("id", table.lastRowIndex());
  newRow.setString("species", "Panthera leo");
  newRow.setString("name", "Lion");
  return table;
}
