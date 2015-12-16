import org.apache.http.HttpEntity;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;

boolean fileUpload(String url, String imgFileName) {

  String imgFilePath = "C:/"+imgFileName;
  
  try {
    DefaultHttpClient httpClient = new DefaultHttpClient();
 
    HttpPost  httpPost   = new HttpPost( url );
    
    File upfile = new File( imgFilePath );
    //File txtUpfile = new File( txtFilePath );

    MultipartEntity mentity = new MultipartEntity();
    
    mentity.addPart("imgFile", new FileBody(upfile));
    mentity.addPart("imgFileName", new StringBody(imgFileName));
 
    httpPost.setEntity(mentity);
 
    HttpResponse response = httpClient.execute( httpPost );
    HttpEntity   entity   = response.getEntity();
 
    println("----------------------------------------");
    println( response.getStatusLine() );
    println("----------------------------------------");
 
    if ( entity != null ) entity.writeTo( System.out );
    if ( entity != null ) entity.consumeContent();
 
    httpClient.getConnectionManager().shutdown();
  } 
  catch(Exception e) {
    e.printStackTrace();
    return false;
  }
  return true;
}

boolean rankingUpload(String url, String playerName, String point) {
  
  try {
    DefaultHttpClient httpClient = new DefaultHttpClient();
 
    HttpPost  httpPost   = new HttpPost( url );
    
    MultipartEntity mentity = new MultipartEntity();
    
    mentity.addPart("playerName", new StringBody(playerName));
    mentity.addPart("point", new StringBody(point));
 
    httpPost.setEntity(mentity);
 
    HttpResponse response = httpClient.execute( httpPost );
    HttpEntity   entity   = response.getEntity();
 
    println("----------------------------------------");
    println( response.getStatusLine() );
    println("----------------------------------------");
 
    if ( entity != null ) entity.writeTo( System.out );
    if ( entity != null ) entity.consumeContent();
 
    httpClient.getConnectionManager().shutdown();
  } 
  catch(Exception e) {
    e.printStackTrace();
    return false;
  }
  return true;
}