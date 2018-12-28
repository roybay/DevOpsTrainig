package default

import scala.concurrent.duration._

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._

class OpenigHelloSimulation extends Simulation {

	val httpProtocol = http
		.baseURL("http://detectportal.firefox.com")
		.inferHtmlResources()
		.acceptHeader("*/*")
		.acceptEncodingHeader("gzip, deflate")
		.acceptLanguageHeader("en-US,en;q=0.5")
		.userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:61.0) Gecko/20100101 Firefox/61.0")

	val headers_0 = Map("Pragma" -> "no-cache")

	val headers_6 = Map(
		"Accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Upgrade-Insecure-Requests" -> "1")

    val uri1 = "http://35.237.133.72:8080/public.html"

	val scn = scenario("OpenigHelloSimulation")
		.exec(
            http("request_0")
			.get(uri1 + "")
			.headers(headers_6))

	setUp(
		scn.inject( constantUsersPerSec(125) during (300 seconds) )
	).protocols(httpProtocol)
}