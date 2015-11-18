import org.apache.http.HttpEntity;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;

boolean Upload(String url, String imgFileName, String textFileName) {

  String imgFilePath = "C:/"+imgFileName;
  String txtFilePath = "C:/"+textFileName;
  
  try {
    DefaultHttpClient httpClient = new DefaultHttpClient();
 
    HttpPost  httpPost   = new HttpPost( url );
    
    File upfile = new File( imgFilePath );
    File txtUpfile = new File( txtFilePath );

    MultipartEntity mentity = new MultipartEntity();
    
    mentity.addPart("imgFile", new FileBody(upfile));
    mentity.addPart("txtFile", new FileBody(txtUpfile));
    mentity.addPart("imgFileName", new StringBody(imgFileName));
    mentity.addPart("txtFileName", new StringBody(textFileName));
 
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