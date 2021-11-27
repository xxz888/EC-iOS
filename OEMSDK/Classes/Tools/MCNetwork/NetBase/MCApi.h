//
//  MCApi.h
//  MCOEM
//
//  Created by Nitch Zheng on 2020/3/18.
//  Copyright © 2020 MingChe. All rights reserved.
//

#ifndef MCApi_h
#define MCApi_h


#define api_host                MCModelStore.shared.userDefaults.host

//返回host
#define api_requstiosaddress    @"/user/app/get/ios/brand/request/address"
#define api_sendsms             @"/notice/app/sms/send"
#define api_updateloginpwd      @"/user/app/password/update"
#define api_updatepaypwd        @"/user/app/paypass/update/"
#define api_verifypaypwd        @"/user/app/paypass/auth/"


#endif /* MCApi_h */
