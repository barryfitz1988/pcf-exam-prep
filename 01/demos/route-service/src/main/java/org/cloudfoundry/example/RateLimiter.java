package org.cloudfoundry.example;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.RequestEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.URISyntaxException;

@Component
public class RateLimiter {
  private final static Logger logger = LoggerFactory.getLogger(RateLimiter.class);

  private final String KEY = "host";

  @Autowired
  private StringRedisTemplate redisTemplate;


  @Scheduled(fixedRate = 15000)
  public void resetCounts() {
    redisTemplate.delete(KEY);
    logger.debug("Starting new 15 second interval");
  }

  public boolean rateLimitRequest(RequestEntity<?> incoming) {
    String forwardUrl = incoming.getHeaders().get(Controller.FORWARDED_URL).get(0);
    URI uri;
    try {
      uri = new URI(forwardUrl);
    } catch (URISyntaxException e) {
      logger.error("error parsing url", e);
      return false;
    }

    String host = uri.getHost();
    String value = (String) redisTemplate.opsForHash().get(KEY, host);
    int requestsPerInterval = 1;
    if (value == null) {
      redisTemplate.opsForHash().put(KEY, host, "1");
    } else {
      requestsPerInterval = Integer.parseInt(value) + 1;
      redisTemplate.opsForHash().increment(KEY, host, 1);
    }

    return (requestsPerInterval > 3);
  }
}
