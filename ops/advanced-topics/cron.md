---
title: cron
id: cron
---
ODE Framework provides a library to schedule tasks with cron expression. Its source code is available in [vertx-cron-timer repository](https://github.com/web-education/vertx-cron-timer/commits/master) It uses the cron expression implementation from [Quartz](http://www.quartz-scheduler.org/documentation/quartz-2.x/tutorials/crontrigger.html) and the Vertx’s timer.

# Adds dependency to library

**Adding a version property to the gradle.properties**:

    vertxCronTimer=1.0.1

> **Note**
>
> Choose the last git tag, 1.0.1 nowadays

**Adding dependency to library in build.gradle**:

``` json
dependencies {
    ...
    compile "fr.wseduc:vertx-cron-timer:$vertxCronTimer"
    ...
}
```

# Implements your Job

**Create a class that implement *Handler&lt;Long&gt;* :**

``` java
public class $JobClassName implements Handler<Long> {

    public $JobClassName() {}

    @Override
    public void handle(Long event) {
        // Writes the code to run here
    }
}
```

# Schedules your job with a cron expression

``` java
public class $VerticuleAppName extends BaseServer {

    @Override
    public void start() {
        super.start();

        ....

        // Example : here the default cron expression is "every day at 4am"
        final String cronExpression = container.config().getString("$yourProperty$Cron", "0 0 4 * * ?");

        try {
            new CronTrigger(vertx, cronExpression).schedule(
                    new $JobClassName()
            );
        } catch (ParseException e) {
            log.fatal("Invalid cron expression.", e);
            vertx.stop();
        }
    }
}
```

> **Note**
>
> schedule jobs are usually declare in the main verticle of your application. It’s a good place to init your application’s context. .

> **Warning**
>
> Your application must contain a configuration property to ajust the default cron expression. Hard coded cron expressions are to avoid.
