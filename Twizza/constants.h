//
//  constants.h
//  Twizza
//
//  Created by Dongmei Hu on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Twizza_constants_h
#define Twizza_constants_h

//fetchAdvancedUserProperties
#define TWITTER_FETCH_ACCOUNT_DATA @"https://api.twitter.com/1/users/show.json"
#define TWITTER_FETCH_TIMELINE @"https://api.twitter.com/1/statuses/home_timeline.json"
#define TWITTER_FETCH_PROFILE_IMAGE @"http://api.twitter.com/1/users/profile_image/%@"
#define TWITTER_SERACH_WITHOUT_Q @"http://search.twitter.com/search.json?q="
#define TWITTER_FETCH_SUGGESTION @"https://api.twitter.com/1/users/suggestions.json"


#ifdef DEBUG
#define TWIZZA_HOST_URL @"http://localhost:8888"
#endif

#ifndef TWIZZA_HOST_URL
//#define TWIZZA_HOST_URL @"http://zoe4meii.com/twizza"
#endif

#define SERVER_GET_TOPIC_LIST_PHP getuserstopics

#endif
