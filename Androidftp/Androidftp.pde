//IMPORTANT ANDROID SKETCH PERMISSIONS : INTERNET, READ EXTERNAL STORAGE, WRITE EXTERNAL STORAGE

void setup() {
  boolean inandroid =false;
  Table table = exampletable();
  uploadtableftp(table,inandroid,"tabla2","csv","pruebas/","files.000webhost.com", 21, "martinstacey", "elmascapo");
  //table = downloadtableftp(inandroid,"tabla2","csv","pruebas/","files.000webhost.com", 21, "martinstacey", "elmascapo");
  background(255, 0, 0);
}
