void filePost(String imgFileName){ 
  fileUpload("http://japaan.jp/hal/mago/upload/", imgFileName);
}

void rankingPost(String playerName, String point){
  rankingUpload("http://japaan.jp/hal/mago/ranking/", playerName, point);
}