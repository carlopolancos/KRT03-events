package eventsapi

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._
import scala.language.postfixOps

class MySimulation extends Simulation {

  val getEvents =
    scenario("load-events")
      .exec(karateFeature("classpath:eventsapi/events/publicevents.feature"))

  val auth =
    scenario("authentication")
      .exec(karateFeature("classpath:eventsapi/events/authentication.feature"))

  setUp(
    getEvents.inject(rampUsers(100) during (5)),
    auth.inject(rampUsers(500) during (5))
  )
}
