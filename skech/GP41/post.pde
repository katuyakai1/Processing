void filePost(String imgFileName, String textFileName){ 
  fileUpload("http://japaan.jp/hal/mago/upload/", imgFileName, textFileName);
}

void rankingPost(String playerName, String point){
  rankingUpload("http://japaan.jp/hal/mago/ranking/", playerName, point);
}