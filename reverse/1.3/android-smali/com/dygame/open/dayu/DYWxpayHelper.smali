.class public Lcom/dygame/open/dayu/DYWxpayHelper;
.super Ljava/lang/Object;
.source "DYWxpayHelper.java"


# static fields
.field public static final APPID:Ljava/lang/String; = "wxb6cee11fe75e9b6f"

.field public static final APPKEY:Ljava/lang/String; = "b3a18ed87ef16a91fac178150d060f18"

.field public static final NONCE_KEY:Ljava/lang/String; = "480a0597-a9d7-48e8-a757-b6590a2b0ba5"

.field public static final NOTIFY_URL:Ljava/lang/String; = "http://platform.xxxy.dayukeji.com:10116/WebRoot/pay/wechatcallback"

.field public static final NOTIFY_URL_DEBUG:Ljava/lang/String; = "http://stest.xxxy.dayukeji.com:9990/Payment/payment/wechatpaycallback/"

.field public static final PARTNER:Ljava/lang/String; = "1300414901"

.field private static mInstance:Lcom/dygame/open/dayu/DYWxpayHelper;


# instance fields
.field private api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 26
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/open/dayu/DYWxpayHelper;->mInstance:Lcom/dygame/open/dayu/DYWxpayHelper;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 67
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/dygame/open/dayu/DYWxpayHelper;->api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    return-void
.end method

.method static synthetic access$000(Lcom/dygame/open/dayu/DYWxpayHelper;)Lcom/tencent/mm/opensdk/openapi/IWXAPI;
    .locals 1
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYWxpayHelper;

    .prologue
    .line 25
    iget-object v0, p0, Lcom/dygame/open/dayu/DYWxpayHelper;->api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    return-object v0
.end method

.method public static getInstance()Lcom/dygame/open/dayu/DYWxpayHelper;
    .locals 1

    .prologue
    .line 28
    sget-object v0, Lcom/dygame/open/dayu/DYWxpayHelper;->mInstance:Lcom/dygame/open/dayu/DYWxpayHelper;

    if-nez v0, :cond_0

    .line 29
    new-instance v0, Lcom/dygame/open/dayu/DYWxpayHelper;

    invoke-direct {v0}, Lcom/dygame/open/dayu/DYWxpayHelper;-><init>()V

    sput-object v0, Lcom/dygame/open/dayu/DYWxpayHelper;->mInstance:Lcom/dygame/open/dayu/DYWxpayHelper;

    .line 30
    sget-object v0, Lcom/dygame/open/dayu/DYWxpayHelper;->mInstance:Lcom/dygame/open/dayu/DYWxpayHelper;

    invoke-virtual {v0}, Lcom/dygame/open/dayu/DYWxpayHelper;->init()V

    .line 32
    :cond_0
    sget-object v0, Lcom/dygame/open/dayu/DYWxpayHelper;->mInstance:Lcom/dygame/open/dayu/DYWxpayHelper;

    return-object v0
.end method

.method public static getLocalIp()Ljava/lang/String;
    .locals 6

    .prologue
    .line 215
    sget-object v4, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v5, "wifi"

    invoke-virtual {v4, v5}, Lcom/dygame/common/DYGame;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/net/wifi/WifiManager;

    .line 217
    .local v3, "wifiManager":Landroid/net/wifi/WifiManager;
    invoke-virtual {v3}, Landroid/net/wifi/WifiManager;->isWifiEnabled()Z

    move-result v4

    if-nez v4, :cond_0

    .line 218
    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Landroid/net/wifi/WifiManager;->setWifiEnabled(Z)Z

    .line 221
    :cond_0
    invoke-virtual {v3}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v2

    .line 222
    .local v2, "wifiInfo":Landroid/net/wifi/WifiInfo;
    invoke-virtual {v2}, Landroid/net/wifi/WifiInfo;->getIpAddress()I

    move-result v1

    .line 223
    .local v1, "ipAddress":I
    invoke-static {v1}, Lcom/dygame/open/dayu/DYWxpayHelper;->intToIp(I)Ljava/lang/String;

    move-result-object v0

    .line 224
    .local v0, "ip":Ljava/lang/String;
    return-object v0
.end method

.method private static intToIp(I)Ljava/lang/String;
    .locals 2
    .param p0, "i"    # I

    .prologue
    .line 227
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    and-int/lit16 v1, p0, 0xff

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    shr-int/lit8 v1, p0, 0x8

    and-int/lit16 v1, v1, 0xff

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    shr-int/lit8 v1, p0, 0x10

    and-int/lit16 v1, v1, 0xff

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    shr-int/lit8 v1, p0, 0x18

    and-int/lit16 v1, v1, 0xff

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method public init()V
    .locals 3

    .prologue
    .line 70
    sget-object v1, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const/4 v2, 0x0

    invoke-static {v1, v2}, Lcom/tencent/mm/opensdk/openapi/WXAPIFactory;->createWXAPI(Landroid/content/Context;Ljava/lang/String;)Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    move-result-object v0

    .line 72
    .local v0, "msgApi":Lcom/tencent/mm/opensdk/openapi/IWXAPI;
    const-string v1, "wxb6cee11fe75e9b6f"

    invoke-interface {v0, v1}, Lcom/tencent/mm/opensdk/openapi/IWXAPI;->registerApp(Ljava/lang/String;)Z

    .line 74
    sget-object v1, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v2, "wxb6cee11fe75e9b6f"

    invoke-static {v1, v2}, Lcom/tencent/mm/opensdk/openapi/WXAPIFactory;->createWXAPI(Landroid/content/Context;Ljava/lang/String;)Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    move-result-object v1

    iput-object v1, p0, Lcom/dygame/open/dayu/DYWxpayHelper;->api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    .line 75
    return-void
.end method

.method public pay(Ljava/lang/String;)V
    .locals 23
    .param p1, "strParam"    # Ljava/lang/String;
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "DefaultLocale"
        }
    .end annotation

    .prologue
    .line 80
    move-object/from16 v0, p0

    iget-object v0, v0, Lcom/dygame/open/dayu/DYWxpayHelper;->api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    move-object/from16 v17, v0

    if-eqz v17, :cond_0

    move-object/from16 v0, p0

    iget-object v0, v0, Lcom/dygame/open/dayu/DYWxpayHelper;->api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    move-object/from16 v17, v0

    invoke-interface/range {v17 .. v17}, Lcom/tencent/mm/opensdk/openapi/IWXAPI;->isWXAppInstalled()Z

    move-result v17

    if-eqz v17, :cond_0

    move-object/from16 v0, p0

    iget-object v0, v0, Lcom/dygame/open/dayu/DYWxpayHelper;->api:Lcom/tencent/mm/opensdk/openapi/IWXAPI;

    move-object/from16 v17, v0

    invoke-interface/range {v17 .. v17}, Lcom/tencent/mm/opensdk/openapi/IWXAPI;->isWXAppSupportAPI()Z

    move-result v17

    if-nez v17, :cond_1

    .line 81
    :cond_0
    sget-object v17, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v18, "\u542f\u52a8\u5fae\u4fe1\u652f\u4ed8\u5931\u8d25"

    const/16 v19, 0x1

    invoke-static/range {v17 .. v19}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Landroid/widget/Toast;->show()V

    .line 82
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v17

    const/16 v18, 0x0

    invoke-virtual/range {v17 .. v18}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    .line 210
    :goto_0
    return-void

    .line 86
    :cond_1
    const/4 v6, 0x0

    .line 88
    .local v6, "jObj":Lorg/json/JSONObject;
    :try_start_0
    new-instance v6, Lorg/json/JSONObject;

    .end local v6    # "jObj":Lorg/json/JSONObject;
    move-object/from16 v0, p1

    invoke-direct {v6, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 94
    .restart local v6    # "jObj":Lorg/json/JSONObject;
    const-string v17, "name"

    const-string v18, ""

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v6, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 95
    .local v9, "pName":Ljava/lang/String;
    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v17

    if-nez v17, :cond_2

    .line 96
    const-string v9, "\u5c0f\u5c0f\u897f\u6e38OL"

    .line 98
    :cond_2
    const-string v17, "desc"

    const-string v18, ""

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v6, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 99
    .local v8, "pDesc":Ljava/lang/String;
    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v17

    if-nez v17, :cond_3

    .line 100
    move-object v8, v9

    .line 102
    :cond_3
    const-string v17, "price"

    const-string v18, "0.01"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v6, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 104
    .local v11, "pPrice":Ljava/lang/String;
    invoke-static {v11}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v17

    const/high16 v18, 0x42c80000    # 100.0f

    mul-float v17, v17, v18

    move/from16 v0, v17

    float-to-double v0, v0

    move-wide/from16 v18, v0

    invoke-static/range {v18 .. v19}, Ljava/lang/Math;->floor(D)D

    move-result-wide v18

    move-wide/from16 v0, v18

    double-to-int v7, v0

    .line 105
    .local v7, "nPrice":I
    invoke-static {v7}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v11

    .line 108
    const-string v17, "orderId"

    move-object/from16 v0, v17

    invoke-virtual {v6, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 109
    .local v2, "appOrderId":Ljava/lang/String;
    new-instance v17, Ljava/lang/StringBuilder;

    invoke-direct/range {v17 .. v17}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v17

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v18, "480a0597-a9d7-48e8-a757-b6590a2b0ba5"

    invoke-virtual/range {v17 .. v18}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v17

    invoke-static/range {v17 .. v17}, Lcom/dygame/common/DYUtils;->getMD5(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 117
    .local v10, "pNounce":Ljava/lang/String;
    new-instance v12, Ljava/util/TreeMap;

    invoke-direct {v12}, Ljava/util/TreeMap;-><init>()V

    .line 118
    .local v12, "param":Ljava/util/TreeMap;, "Ljava/util/TreeMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v17, "appid"

    const-string v18, "wxb6cee11fe75e9b6f"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v12, v0, v1}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 119
    const-string v17, "mch_id"

    const-string v18, "1300414901"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v12, v0, v1}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 121
    const-string v17, "nonce_str"

    move-object/from16 v0, v17

    invoke-virtual {v12, v0, v10}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 123
    const-string v17, "body"

    new-instance v18, Ljava/lang/StringBuilder;

    invoke-direct/range {v18 .. v18}, Ljava/lang/StringBuilder;-><init>()V

    const-string v19, "\u5c0f\u5c0f\u897f\u6e38OL-"

    invoke-virtual/range {v18 .. v19}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v18

    move-object/from16 v0, v18

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v18

    invoke-virtual/range {v18 .. v18}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v18

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v12, v0, v1}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 126
    const-string v17, "out_trade_no"

    move-object/from16 v0, v17

    invoke-virtual {v12, v0, v2}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 128
    const-string v17, "total_fee"

    move-object/from16 v0, v17

    invoke-virtual {v12, v0, v11}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 129
    const-string v17, "spbill_create_ip"

    invoke-static {}, Lcom/dygame/open/dayu/DYWxpayHelper;->getLocalIp()Ljava/lang/String;

    move-result-object v18

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v12, v0, v1}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 133
    const-string v17, "notify_url"

    const-string v18, "http://platform.xxxy.dayukeji.com:10116/WebRoot/pay/wechatcallback"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v12, v0, v1}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 134
    const-string v17, "trade_type"

    const-string v18, "APP"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-virtual {v12, v0, v1}, Ljava/util/TreeMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 137
    const-string v15, ""

    .line 138
    .local v15, "strOrderParam":Ljava/lang/String;
    const-string v13, ""

    .line 139
    .local v13, "strEntity":Ljava/lang/String;
    invoke-virtual {v12}, Ljava/util/TreeMap;->entrySet()Ljava/util/Set;

    move-result-object v17

    invoke-interface/range {v17 .. v17}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v18

    :goto_1
    invoke-interface/range {v18 .. v18}, Ljava/util/Iterator;->hasNext()Z

    move-result v17

    if-eqz v17, :cond_5

    invoke-interface/range {v18 .. v18}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/Map$Entry;

    .line 140
    .local v5, "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-virtual {v15}, Ljava/lang/String;->length()I

    move-result v17

    if-lez v17, :cond_4

    .line 141
    new-instance v17, Ljava/lang/StringBuilder;

    invoke-direct/range {v17 .. v17}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v17

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v19, "&"

    move-object/from16 v0, v17

    move-object/from16 v1, v19

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v15

    .line 143
    :cond_4
    new-instance v17, Ljava/lang/StringBuilder;

    invoke-direct/range {v17 .. v17}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v17

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v19

    invoke-interface {v5}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v17

    check-cast v17, Ljava/lang/String;

    move-object/from16 v0, v19

    move-object/from16 v1, v17

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v19, "="

    move-object/from16 v0, v17

    move-object/from16 v1, v19

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v19

    invoke-interface {v5}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v17

    check-cast v17, Ljava/lang/String;

    move-object/from16 v0, v19

    move-object/from16 v1, v17

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v15

    .line 144
    new-instance v17, Ljava/lang/StringBuilder;

    invoke-direct/range {v17 .. v17}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v17

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v19, "<%s>%s</%s>"

    const/16 v20, 0x3

    move/from16 v0, v20

    new-array v0, v0, [Ljava/lang/Object;

    move-object/from16 v20, v0

    const/16 v21, 0x0

    invoke-interface {v5}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v22

    aput-object v22, v20, v21

    const/16 v21, 0x1

    invoke-interface {v5}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v22

    aput-object v22, v20, v21

    const/16 v21, 0x2

    invoke-interface {v5}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v22

    aput-object v22, v20, v21

    invoke-static/range {v19 .. v20}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v19

    move-object/from16 v0, v17

    move-object/from16 v1, v19

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    .line 145
    goto/16 :goto_1

    .line 89
    .end local v2    # "appOrderId":Ljava/lang/String;
    .end local v5    # "entry":Ljava/util/Map$Entry;, "Ljava/util/Map$Entry<Ljava/lang/String;Ljava/lang/String;>;"
    .end local v6    # "jObj":Lorg/json/JSONObject;
    .end local v7    # "nPrice":I
    .end local v8    # "pDesc":Ljava/lang/String;
    .end local v9    # "pName":Ljava/lang/String;
    .end local v10    # "pNounce":Ljava/lang/String;
    .end local v11    # "pPrice":Ljava/lang/String;
    .end local v12    # "param":Ljava/util/TreeMap;, "Ljava/util/TreeMap<Ljava/lang/String;Ljava/lang/String;>;"
    .end local v13    # "strEntity":Ljava/lang/String;
    .end local v15    # "strOrderParam":Ljava/lang/String;
    :catch_0
    move-exception v4

    .line 90
    .local v4, "e1":Lorg/json/JSONException;
    invoke-virtual {v4}, Lorg/json/JSONException;->printStackTrace()V

    .line 91
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v17

    const/16 v18, 0x0

    invoke-virtual/range {v17 .. v18}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    goto/16 :goto_0

    .line 146
    .end local v4    # "e1":Lorg/json/JSONException;
    .restart local v2    # "appOrderId":Ljava/lang/String;
    .restart local v6    # "jObj":Lorg/json/JSONObject;
    .restart local v7    # "nPrice":I
    .restart local v8    # "pDesc":Ljava/lang/String;
    .restart local v9    # "pName":Ljava/lang/String;
    .restart local v10    # "pNounce":Ljava/lang/String;
    .restart local v11    # "pPrice":Ljava/lang/String;
    .restart local v12    # "param":Ljava/util/TreeMap;, "Ljava/util/TreeMap<Ljava/lang/String;Ljava/lang/String;>;"
    .restart local v13    # "strEntity":Ljava/lang/String;
    .restart local v15    # "strOrderParam":Ljava/lang/String;
    :cond_5
    new-instance v17, Ljava/lang/StringBuilder;

    invoke-direct/range {v17 .. v17}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v17

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v18, "&key="

    invoke-virtual/range {v17 .. v18}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v18, "b3a18ed87ef16a91fac178150d060f18"

    invoke-virtual/range {v17 .. v18}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v15

    .line 147
    invoke-static {v15}, Lcom/dygame/common/DYUtils;->getMD5(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v16

    .line 148
    .local v16, "strSign":Ljava/lang/String;
    new-instance v17, Ljava/lang/StringBuilder;

    invoke-direct/range {v17 .. v17}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, v17

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    const-string v18, "<%s>%s</%s>"

    const/16 v19, 0x3

    move/from16 v0, v19

    new-array v0, v0, [Ljava/lang/Object;

    move-object/from16 v19, v0

    const/16 v20, 0x0

    const-string v21, "sign"

    aput-object v21, v19, v20

    const/16 v20, 0x1

    aput-object v16, v19, v20

    const/16 v20, 0x2

    const-string v21, "sign"

    aput-object v21, v19, v20

    invoke-static/range {v18 .. v19}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v18

    invoke-virtual/range {v17 .. v18}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    .line 149
    const-string v17, "<xml>%s</xml>"

    const/16 v18, 0x1

    move/from16 v0, v18

    new-array v0, v0, [Ljava/lang/Object;

    move-object/from16 v18, v0

    const/16 v19, 0x0

    aput-object v13, v18, v19

    invoke-static/range {v17 .. v18}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v13

    .line 153
    :try_start_1
    new-instance v14, Ljava/lang/String;

    invoke-virtual {v13}, Ljava/lang/String;->toString()Ljava/lang/String;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/lang/String;->getBytes()[B

    move-result-object v17

    const-string v18, "ISO8859-1"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-direct {v14, v0, v1}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    :try_end_1
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_1 .. :try_end_1} :catch_1

    .end local v13    # "strEntity":Ljava/lang/String;
    .local v14, "strEntity":Ljava/lang/String;
    move-object v13, v14

    .line 159
    .end local v14    # "strEntity":Ljava/lang/String;
    .restart local v13    # "strEntity":Ljava/lang/String;
    :goto_2
    const-string v17, "https://api.mch.weixin.qq.com/pay/unifiedorder"

    new-instance v18, Lcom/dygame/open/dayu/DYWxpayHelper$1;

    move-object/from16 v0, v18

    move-object/from16 v1, p0

    invoke-direct {v0, v1}, Lcom/dygame/open/dayu/DYWxpayHelper$1;-><init>(Lcom/dygame/open/dayu/DYWxpayHelper;)V

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-static {v0, v13, v1}, Lcom/dygame/common/DYHttpMgr;->postEx(Ljava/lang/String;Ljava/lang/String;Lcom/dygame/common/DYHttpMgr$DYHttpHandler;)V

    goto/16 :goto_0

    .line 154
    :catch_1
    move-exception v3

    .line 156
    .local v3, "e":Ljava/io/UnsupportedEncodingException;
    invoke-virtual {v3}, Ljava/io/UnsupportedEncodingException;->printStackTrace()V

    goto :goto_2
.end method
