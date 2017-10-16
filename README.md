# Rate Limiter

Create a new rails application. You can include any gems or other libraries you consider will be helpful. However, you must not use a gem for implementing the rate limiting functionality. 

Create a new controller, perhaps called "home", with an index method. This should return only the text string "ok".

The challenge is to implement rate limiting on this controller. Limit it such that *a requester* can only make 100 requests per hour. After the limit has been reached, return a 429 with the text "Rate limit exceeded. Try again in #{n} seconds".

How you do this is up to you. Think about how easy your rate limiter will be to maintain and control. Try to write what you consider to be production-quality code, with comments and tests if and when you consider them necessary.

When you've finished, send us the link to your repo on github / bitbucket / gitlab or any hosted git repo we can access. Good luck!

# Implementation notes

An in-memory cacheing database such as Redis or memcached is needed to properly handle this at produciton scale, by both limiting the overhead of implementing the rate limiter and maintaining a single record of the number of hits in a period across potentially many application servers.

The term "a requester" could imply either an IP or address or an authenticated user. For the purposes of the exercise I have assumed an IP address. There would be little difference required in the implementation apart from a chaneg in the cahce keys.
