.class public Lorg/cocos2dx/lua/AppActivity;
.super Lorg/cocos2dx/lib/Cocos2dxActivity;
.source "AppActivity.java"


# static fields
.field static UserId:Ljava/lang/String;

.field static hostIPAdress:Ljava/lang/String;

.field public static mIsPaymentOK:I

.field private static payResultListener:Lcn/uc/gamesdk/UCCallbackListener;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Lcn/uc/gamesdk/info/OrderInfo;",
            ">;"
        }
    .end annotation
.end field

.field private static s_instance:Lorg/cocos2dx/lua/AppActivity;


# instance fields
.field private amount:F

.field final me:Lorg/cocos2dx/lua/AppActivity;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 81
    const-string v0, "0.0.0.0"

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->hostIPAdress:Ljava/lang/String;

    .line 83
    const-string v0, ""

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->UserId:Ljava/lang/String;

    .line 454
    const/4 v0, 0x0

    sput v0, Lorg/cocos2dx/lua/AppActivity;->mIsPaymentOK:I

    .line 536
    new-instance v0, Lorg/cocos2dx/lua/AppActivity$1;

    invoke-direct {v0}, Lorg/cocos2dx/lua/AppActivity$1;-><init>()V

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->payResultListener:Lcn/uc/gamesdk/UCCallbackListener;

    .line 563
    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 79
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;-><init>()V

    .line 84
    iput-object p0, p0, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    .line 453
    const/4 v0, 0x0

    iput v0, p0, Lorg/cocos2dx/lua/AppActivity;->amount:F

    .line 79
    return-void
.end method

.method static synthetic access$0(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 155
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkInit()V

    return-void
.end method

.method static synthetic access$1(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 256
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkLogin()V

    return-void
.end method

.method static synthetic access$2(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 359
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkDestoryFloatButton()V

    return-void
.end method

.method static synthetic access$3(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 374
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkLogout()V

    return-void
.end method

.method static synthetic access$4(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 387
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkCreateFloatButton()V

    return-void
.end method

.method static synthetic access$5(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0

    .prologue
    .line 421
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkShowFloatButton()V

    return-void
.end method

.method static synthetic access$6(Lorg/cocos2dx/lua/AppActivity;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .prologue
    .line 342
    invoke-direct {p0, p1, p2}, Lorg/cocos2dx/lua/AppActivity;->verifyGameUser(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$7()Lorg/cocos2dx/lua/AppActivity;
    .locals 1

    .prologue
    .line 86
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->s_instance:Lorg/cocos2dx/lua/AppActivity;

    return-object v0
.end method

.method static synthetic access$8()Lcn/uc/gamesdk/UCCallbackListener;
    .locals 1

    .prologue
    .line 536
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->payResultListener:Lcn/uc/gamesdk/UCCallbackListener;

    return-object v0
.end method

.method public static checkAndGetUCId(I)V
    .locals 2
    .param p0, "luaCallbackFunction"    # I

    .prologue
    .line 623
    const-string v0, "asdasdasd"

    const-string v1, "dsadsadsadsa"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 624
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->s_instance:Lorg/cocos2dx/lua/AppActivity;

    new-instance v1, Lorg/cocos2dx/lua/AppActivity$11;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lua/AppActivity$11;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lua/AppActivity;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 637
    return-void
.end method

.method public static checkIsUCPaySuccess(I)V
    .locals 2
    .param p0, "luaCallbackFunction"    # I

    .prologue
    .line 438
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->s_instance:Lorg/cocos2dx/lua/AppActivity;

    new-instance v1, Lorg/cocos2dx/lua/AppActivity$9;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lua/AppActivity$9;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lua/AppActivity;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 450
    return-void
.end method

.method public static exitUC()V
    .locals 2

    .prologue
    .line 646
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->s_instance:Lorg/cocos2dx/lua/AppActivity;

    new-instance v1, Lorg/cocos2dx/lua/AppActivity$12;

    invoke-direct {v1}, Lorg/cocos2dx/lua/AppActivity$12;-><init>()V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lua/AppActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 663
    return-void
.end method

.method public static getLocalIpAddress()Ljava/lang/String;
    .locals 1

    .prologue
    .line 615
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->hostIPAdress:Ljava/lang/String;

    return-object v0
.end method

.method private isNetworkConnected()Z
    .locals 7

    .prologue
    const/4 v4, 0x1

    .line 588
    const-string v5, "connectivity"

    invoke-virtual {p0, v5}, Lorg/cocos2dx/lua/AppActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/ConnectivityManager;

    .line 589
    .local v0, "cm":Landroid/net/ConnectivityManager;
    if-eqz v0, :cond_0

    .line 590
    invoke-virtual {v0}, Landroid/net/ConnectivityManager;->getActiveNetworkInfo()Landroid/net/NetworkInfo;

    move-result-object v2

    .line 591
    .local v2, "networkInfo":Landroid/net/NetworkInfo;
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 592
    .local v3, "networkTypes":Ljava/util/ArrayList;
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 594
    :try_start_0
    const-class v5, Landroid/net/ConnectivityManager;

    const-string v6, "TYPE_ETHERNET"

    invoke-virtual {v5, v6}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v5

    const/4 v6, 0x0

    invoke-virtual {v5, v6}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/NoSuchFieldException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_0

    .line 600
    :goto_0
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/net/NetworkInfo;->getType()I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 604
    .end local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .end local v3    # "networkTypes":Ljava/util/ArrayList;
    :goto_1
    return v4

    .line 597
    .restart local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .restart local v3    # "networkTypes":Ljava/util/ArrayList;
    :catch_0
    move-exception v1

    .line 598
    .local v1, "iae":Ljava/lang/IllegalAccessException;
    new-instance v4, Ljava/lang/RuntimeException;

    invoke-direct {v4, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v4

    .line 604
    .end local v1    # "iae":Ljava/lang/IllegalAccessException;
    .end local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .end local v3    # "networkTypes":Ljava/util/ArrayList;
    :cond_0
    const/4 v4, 0x0

    goto :goto_1

    .line 595
    .restart local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .restart local v3    # "networkTypes":Ljava/util/ArrayList;
    :catch_1
    move-exception v5

    goto :goto_0
.end method

.method private static native nativeIsDebug()Z
.end method

.method private static native nativeIsLandScape()Z
.end method

.method public static payUC(Ljava/lang/String;I)V
    .locals 2
    .param p0, "billno"    # Ljava/lang/String;
    .param p1, "money"    # I

    .prologue
    .line 458
    const/4 v0, 0x0

    sput v0, Lorg/cocos2dx/lua/AppActivity;->mIsPaymentOK:I

    .line 460
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->s_instance:Lorg/cocos2dx/lua/AppActivity;

    new-instance v1, Lorg/cocos2dx/lua/AppActivity$10;

    invoke-direct {v1, p1, p0}, Lorg/cocos2dx/lua/AppActivity$10;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lua/AppActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 493
    return-void
.end method

.method private ucSdkCreateFloatButton()V
    .locals 1

    .prologue
    .line 388
    new-instance v0, Lorg/cocos2dx/lua/AppActivity$7;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lua/AppActivity$7;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lua/AppActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 414
    return-void
.end method

.method private ucSdkDestoryFloatButton()V
    .locals 1

    .prologue
    .line 360
    new-instance v0, Lorg/cocos2dx/lua/AppActivity$6;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lua/AppActivity$6;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lua/AppActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 366
    return-void
.end method

.method private ucSdkInit()V
    .locals 7

    .prologue
    .line 160
    :try_start_0
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    .line 161
    new-instance v1, Lorg/cocos2dx/lua/AppActivity$3;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lua/AppActivity$3;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    .line 160
    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/UCGameSDK;->setLogoutNotifyListener(Lcn/uc/gamesdk/UCCallbackListener;)V
    :try_end_0
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_0 .. :try_end_0} :catch_2

    .line 196
    :goto_0
    :try_start_1
    new-instance v4, Lcn/uc/gamesdk/info/GameParamInfo;

    invoke-direct {v4}, Lcn/uc/gamesdk/info/GameParamInfo;-><init>()V

    .line 197
    .local v4, "gpi":Lcn/uc/gamesdk/info/GameParamInfo;
    sget v0, Lorg/cocos2dx/lua/UCSdkConfig;->cpId:I

    invoke-virtual {v4, v0}, Lcn/uc/gamesdk/info/GameParamInfo;->setCpId(I)V

    .line 198
    sget v0, Lorg/cocos2dx/lua/UCSdkConfig;->gameId:I

    invoke-virtual {v4, v0}, Lcn/uc/gamesdk/info/GameParamInfo;->setGameId(I)V

    .line 199
    sget v0, Lorg/cocos2dx/lua/UCSdkConfig;->serverId:I

    invoke-virtual {v4, v0}, Lcn/uc/gamesdk/info/GameParamInfo;->setServerId(I)V

    .line 205
    new-instance v0, Lcn/uc/gamesdk/info/FeatureSwitch;

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/info/FeatureSwitch;-><init>(ZZ)V

    invoke-virtual {v4, v0}, Lcn/uc/gamesdk/info/GameParamInfo;->setFeatureSwitch(Lcn/uc/gamesdk/info/FeatureSwitch;)V

    .line 212
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/UCOrientation;->LANDSCAPE:Lcn/uc/gamesdk/UCOrientation;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/UCGameSDK;->setOrientation(Lcn/uc/gamesdk/UCOrientation;)V

    .line 217
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    sget-object v1, Lcn/uc/gamesdk/UCLoginFaceType;->USE_WIDGET:Lcn/uc/gamesdk/UCLoginFaceType;

    invoke-virtual {v0, v1}, Lcn/uc/gamesdk/UCGameSDK;->setLoginUISwitch(Lcn/uc/gamesdk/UCLoginFaceType;)V

    .line 222
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lua/AppActivity;->me:Lorg/cocos2dx/lua/AppActivity;

    sget-object v2, Lcn/uc/gamesdk/UCLogLevel;->DEBUG:Lcn/uc/gamesdk/UCLogLevel;

    .line 223
    sget-boolean v3, Lorg/cocos2dx/lua/UCSdkConfig;->debugMode:Z

    .line 224
    new-instance v5, Lorg/cocos2dx/lua/AppActivity$4;

    invoke-direct {v5, p0}, Lorg/cocos2dx/lua/AppActivity$4;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    .line 222
    invoke-virtual/range {v0 .. v5}, Lcn/uc/gamesdk/UCGameSDK;->initSDK(Landroid/app/Activity;Lcn/uc/gamesdk/UCLogLevel;ZLcn/uc/gamesdk/info/GameParamInfo;Lcn/uc/gamesdk/UCCallbackListener;)V
    :try_end_1
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 245
    .end local v4    # "gpi":Lcn/uc/gamesdk/info/GameParamInfo;
    :goto_1
    return-void

    .line 240
    :catch_0
    move-exception v6

    .line 241
    .local v6, "e":Lcn/uc/gamesdk/UCCallbackListenerNullException;
    invoke-virtual {v6}, Lcn/uc/gamesdk/UCCallbackListenerNullException;->printStackTrace()V

    goto :goto_1

    .line 242
    .end local v6    # "e":Lcn/uc/gamesdk/UCCallbackListenerNullException;
    :catch_1
    move-exception v6

    .line 243
    .local v6, "e":Ljava/lang/Exception;
    invoke-virtual {v6}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    .line 191
    .end local v6    # "e":Ljava/lang/Exception;
    :catch_2
    move-exception v0

    goto :goto_0
.end method

.method private ucSdkLogin()V
    .locals 1

    .prologue
    .line 258
    new-instance v0, Lorg/cocos2dx/lua/AppActivity$5;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lua/AppActivity$5;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lua/AppActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 336
    return-void
.end method

.method private ucSdkLogout()V
    .locals 1

    .prologue
    .line 376
    :try_start_0
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v0

    invoke-virtual {v0}, Lcn/uc/gamesdk/UCGameSDK;->logout()V
    :try_end_0
    .catch Lcn/uc/gamesdk/UCCallbackListenerNullException; {:try_start_0 .. :try_end_0} :catch_0

    .line 380
    :goto_0
    return-void

    .line 377
    :catch_0
    move-exception v0

    goto :goto_0
.end method

.method private ucSdkShowFloatButton()V
    .locals 1

    .prologue
    .line 422
    new-instance v0, Lorg/cocos2dx/lua/AppActivity$8;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lua/AppActivity$8;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lua/AppActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 433
    return-void
.end method

.method private ucSdkSubmitExtendData()V
    .locals 3

    .prologue
    .line 572
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 573
    .local v0, "jsonExData":Lorg/json/JSONObject;
    const-string v1, "roleId"

    const-string v2, "R0010"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 574
    const-string v1, "roleName"

    const-string v2, "\u4ee4\u72d0\u4e00\u51b2"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 575
    const-string v1, "roleLevel"

    const-string v2, "99"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 576
    const-string v1, "zoneId"

    const v2, 0x2f139

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 577
    const-string v1, "zoneName"

    const-string v2, "\u6e38\u620f\u4e00\u533a-\u900d\u9065\u8c37"

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 578
    invoke-static {}, Lcn/uc/gamesdk/UCGameSDK;->defaultSDK()Lcn/uc/gamesdk/UCGameSDK;

    move-result-object v1

    .line 579
    const-string v2, "loginGameRole"

    invoke-virtual {v1, v2, v0}, Lcn/uc/gamesdk/UCGameSDK;->submitExtendData(Ljava/lang/String;Lorg/json/JSONObject;)V

    .line 580
    const-string v1, "UCGameSDK"

    const-string v2, "\u63d0\u4ea4\u6e38\u620f\u6269\u5c55\u6570\u636e\u529f\u80fd\u8c03\u7528\u6210\u529f"

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 584
    .end local v0    # "jsonExData":Lorg/json/JSONObject;
    :goto_0
    return-void

    .line 581
    :catch_0
    move-exception v1

    goto :goto_0
.end method

.method private verifyGameUser(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .param p1, "username"    # Ljava/lang/String;
    .param p2, "password"    # Ljava/lang/String;

    .prologue
    .line 343
    const-string v0, ""

    .line 345
    .local v0, "sid":Ljava/lang/String;
    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 346
    const-string v0, "0c3b8357-2b24-4b2f-97d9-c14ff687bd6d113550"

    .line 350
    :goto_0
    return-object v0

    .line 348
    :cond_0
    const-string v0, ""

    goto :goto_0
.end method


# virtual methods
.method public getHostIpAddress()Ljava/lang/String;
    .locals 5

    .prologue
    .line 608
    const-string v3, "wifi"

    invoke-virtual {p0, v3}, Lorg/cocos2dx/lua/AppActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/wifi/WifiManager;

    .line 609
    .local v2, "wifiMgr":Landroid/net/wifi/WifiManager;
    invoke-virtual {v2}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v1

    .line 610
    .local v1, "wifiInfo":Landroid/net/wifi/WifiInfo;
    invoke-virtual {v1}, Landroid/net/wifi/WifiInfo;->getIpAddress()I

    move-result v0

    .line 611
    .local v0, "ip":I
    new-instance v3, Ljava/lang/StringBuilder;

    and-int/lit16 v4, v0, 0xff

    invoke-static {v4}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "."

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    ushr-int/lit8 v0, v0, 0x8

    and-int/lit16 v4, v0, 0xff

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "."

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    ushr-int/lit8 v0, v0, 0x8

    and-int/lit16 v4, v0, 0xff

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "."

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    ushr-int/lit8 v0, v0, 0x8

    and-int/lit16 v4, v0, 0xff

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    return-object v3
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    const/16 v5, 0x80

    const/4 v4, 0x1

    .line 90
    invoke-super {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onCreate(Landroid/os/Bundle;)V

    .line 91
    sput-object p0, Lorg/cocos2dx/lua/AppActivity;->s_instance:Lorg/cocos2dx/lua/AppActivity;

    .line 94
    const/16 v1, 0x5a

    invoke-static {v1}, Lcom/dataeye/DCAgent;->setUploadInterval(I)V

    .line 96
    const/4 v1, 0x2

    invoke-static {v1}, Lcom/dataeye/DCAgent;->setReportMode(I)V

    .line 97
    invoke-static {v4}, Lcom/dataeye/DCAgent;->setDebugMode(Z)V

    .line 100
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    .line 101
    const/4 v2, 0x0

    .line 102
    const-string v3, "api_key"

    invoke-static {p0, v3}, Lorg/cocos2dx/lua/MyUtils;->getMetaValue(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 100
    invoke-static {v1, v2, v3}, Lcom/baidu/android/pushservice/PushManager;->startWork(Landroid/content/Context;ILjava/lang/String;)V

    .line 104
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->ucSdkInit()V

    .line 106
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->nativeIsLandScape()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 107
    const/4 v1, 0x6

    invoke-virtual {p0, v1}, Lorg/cocos2dx/lua/AppActivity;->setRequestedOrientation(I)V

    .line 115
    :goto_0
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->nativeIsDebug()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 117
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1, v5, v5}, Landroid/view/Window;->setFlags(II)V

    .line 118
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->isNetworkConnected()Z

    move-result v1

    if-nez v1, :cond_0

    .line 120
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 121
    .local v0, "builder":Landroid/app/AlertDialog$Builder;
    const-string v1, "Warning"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 122
    const-string v1, "Please open WIFI for debuging..."

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 123
    const-string v1, "OK"

    new-instance v2, Lorg/cocos2dx/lua/AppActivity$2;

    invoke-direct {v2, p0}, Lorg/cocos2dx/lua/AppActivity$2;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    .line 133
    const-string v1, "Cancel"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    .line 134
    invoke-virtual {v0, v4}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    .line 135
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 138
    .end local v0    # "builder":Landroid/app/AlertDialog$Builder;
    :cond_0
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getHostIpAddress()Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lorg/cocos2dx/lua/AppActivity;->hostIPAdress:Ljava/lang/String;

    .line 139
    return-void

    .line 109
    :cond_1
    const/4 v1, 0x7

    invoke-virtual {p0, v1}, Lorg/cocos2dx/lua/AppActivity;->setRequestedOrientation(I)V

    goto :goto_0
.end method

.method public onPause()V
    .locals 0

    .prologue
    .line 147
    invoke-super {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onPause()V

    .line 148
    invoke-static {p0}, Lcom/dataeye/DCAgent;->onPause(Landroid/content/Context;)V

    .line 149
    return-void
.end method

.method public onResume()V
    .locals 0

    .prologue
    .line 143
    invoke-super {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onResume()V

    .line 144
    invoke-static {p0}, Lcom/dataeye/DCAgent;->onResume(Landroid/content/Context;)V

    .line 145
    return-void
.end method
