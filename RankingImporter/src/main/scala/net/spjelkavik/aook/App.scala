package net.spjelkavik.aook

import collection.Map
import collection.immutable.{Map => IMap}
import dispatch._

/**
 * @author ${user.name}
 */
object App {
  
  def foo(x : Array[String]) = x.foldLeft("")((a,b) => a + b)
  
  def main(args : Array[String]) {
    println( "Hello World!" )
    println("concat arguments = " + foo(args))
    importer()
  }

  def importer() {
      val h = new Http
	  val req = url( "https://eventor.orientering.no/api/organisation/apiKey" )  <:< IMap("ApiKey" -> "8c9ffc05a6c44fdc8a26a0daefce4bfa")
	  val handler = req >>> System.out
	  h(handler)
	  }
  //  curl -H "ApiKey:8c9ffc05a6c44fdc8a26a0daefce4bfa" --insecure "https://eventor.orientering.no/api/events?fromDate=2012-04-15&toDate=2012-05-01" | xmllint.exe --format - | grep kjappen -B 3


// curl -H "ApiKey:8c9ffc05a6c44fdc8a26a0daefce4bfa" --insecure "https://eventor.orientering.no/api/results/event?eventId=467" | xmllint.exe --format -  > lk.txt



  // 467 LKjappen
  /*
  H 15-16
  H 13-14
  D 15-16
  D 13-14
  */

  /*

DL class.
Parse class, add runners if they don't exist, add result

Series; calc points.

ClassResult[EventClass/ClassShortName='H 13-14']

  */

}
