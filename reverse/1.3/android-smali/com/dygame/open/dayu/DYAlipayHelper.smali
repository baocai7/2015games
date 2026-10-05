.class public Lcom/dygame/open/dayu/DYAlipayHelper;
.super Ljava/lang/Object;
.source "DYAlipayHelper.java"


# static fields
.field public static final NOTIFY_URL:Ljava/lang/String; = "http://platform.xxxy.dayukeji.com:9999/Payment/payment/alipaycallback"

.field public static final PARTNER:Ljava/lang/String; = "2088002219936822"

.field public static final RSA_PRIVATE:Ljava/lang/String; = "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAM3IygQphzm/sehvqC9YOm7Uz8JqqP3e5wu2JO8EHQj/oI3f/QKsyMdtU+P54SR0FwjFWPvfCG+7rOh2K5UAqaHWa5cpYKHO6oYYHcsDahvSRQpPp+Ckj5ZrK+2TXZu7gr/VoZ3WNaLtNBL3Fn6mzpIz0G4jH+tl6wlFP9uAFlCrAgMBAAECgYEArWrhe8J3d94pEmVOSZ/DlnT3JLL3+QGomcEEvPwtb9Dkv8scD+4GQbHLeZqx9iNy6exNgezB0k9JdplnPulRCVLhcVlrc6xRfPQIewQ7Eb3s7QPortXQkOS6nF93txrBM5Et24Qwg8b6YztQFjyilnUc0wr399mYCaUOySMmcHECQQD0s5Fbs/zYAobei6MTr6YP0qs73HHOmEOsGpuEJmegjB2fS3dL+z30uyu7lehyGzDI3+x9dm3pCT/BZ+q0UUgZAkEA10k2HzIEvl6Qt9xe5dwJsFahNYpoAXrdFEsonraSo5TLx4UNJwnQA8IicJfJycViJsgRXSciTieTBvouJfzHYwJBAO+Mfoc0exiH2LoyHrId6MZiqQjP9IWX39+yqH3FDvtHT5Rqz12Nlghn1xcrWMOjxK1RMPVdo5lXWZefgE+HprkCQQC+7L2j0s8kKWd8t2ItxgONsHZNrk5oqZaxLap7fvzzN721V0j/yxMAkkXKxsJ9P6C5Ngs4KsGgwDYDJRKSO+hzAkBAEnx73hiMyQiFpTMiDMZgSg3kJhfjIp57Yyn6nTh6F6l7y8fqlOz3FPYeToeUJr6c6ovKl27MIwYuPXdpOC5/"

.field public static final RSA_PUBLIC:Ljava/lang/String; = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

.field private static final SDK_CHECK_FLAG:I = 0x2

.field private static final SDK_PAY_FLAG:I = 0x1

.field public static final SELLER:Ljava/lang/String; = "kuangpanfeng@163.com"

.field private static mAppOrderId:Ljava/lang/String;

.field private static mInstance:Lcom/dygame/open/dayu/DYAlipayHelper;


# instance fields
.field private mHandler:Landroid/os/Handler;
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "HandlerLeak"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 22
    const/4 v0, 0x0

    sput-object v0, Lcom/dygame/open/dayu/DYAlipayHelper;->mInstance:Lcom/dygame/open/dayu/DYAlipayHelper;

    .line 44
    const-string v0, ""

    sput-object v0, Lcom/dygame/open/dayu/DYAlipayHelper;->mAppOrderId:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 46
    new-instance v0, Lcom/dygame/open/dayu/DYAlipayHelper$1;

    invoke-direct {v0, p0}, Lcom/dygame/open/dayu/DYAlipayHelper$1;-><init>(Lcom/dygame/open/dayu/DYAlipayHelper;)V

    iput-object v0, p0, Lcom/dygame/open/dayu/DYAlipayHelper;->mHandler:Landroid/os/Handler;

    return-void
.end method

.method static synthetic access$000(Lcom/dygame/open/dayu/DYAlipayHelper;)Landroid/os/Handler;
    .locals 1
    .param p0, "x0"    # Lcom/dygame/open/dayu/DYAlipayHelper;

    .prologue
    .line 21
    iget-object v0, p0, Lcom/dygame/open/dayu/DYAlipayHelper;->mHandler:Landroid/os/Handler;

    return-object v0
.end method

.method public static getInstance()Lcom/dygame/open/dayu/DYAlipayHelper;
    .locals 1

    .prologue
    .line 24
    sget-object v0, Lcom/dygame/open/dayu/DYAlipayHelper;->mInstance:Lcom/dygame/open/dayu/DYAlipayHelper;

    if-nez v0, :cond_0

    .line 25
    new-instance v0, Lcom/dygame/open/dayu/DYAlipayHelper;

    invoke-direct {v0}, Lcom/dygame/open/dayu/DYAlipayHelper;-><init>()V

    sput-object v0, Lcom/dygame/open/dayu/DYAlipayHelper;->mInstance:Lcom/dygame/open/dayu/DYAlipayHelper;

    .line 27
    :cond_0
    sget-object v0, Lcom/dygame/open/dayu/DYAlipayHelper;->mInstance:Lcom/dygame/open/dayu/DYAlipayHelper;

    return-object v0
.end method


# virtual methods
.method public check(Landroid/view/View;)V
    .locals 2
    .param p1, "v"    # Landroid/view/View;

    .prologue
    .line 182
    new-instance v0, Lcom/dygame/open/dayu/DYAlipayHelper$4;

    invoke-direct {v0, p0}, Lcom/dygame/open/dayu/DYAlipayHelper$4;-><init>(Lcom/dygame/open/dayu/DYAlipayHelper;)V

    .line 198
    .local v0, "checkRunnable":Ljava/lang/Runnable;
    new-instance v1, Ljava/lang/Thread;

    invoke-direct {v1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 199
    .local v1, "checkThread":Ljava/lang/Thread;
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 201
    return-void
.end method

.method public getOrderInfo(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p1, "subject"    # Ljava/lang/String;
    .param p2, "body"    # Ljava/lang/String;
    .param p3, "price"    # Ljava/lang/String;

    .prologue
    .line 219
    const-string v0, "partner=\"2088002219936822\""

    .line 220
    .local v0, "orderInfo":Ljava/lang/String;
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&seller_id=\"kuangpanfeng@163.com\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 221
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&out_trade_no=\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Lcom/dygame/open/dayu/DYAlipayHelper;->getOutTradeNo()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 222
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&subject=\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 223
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&body=\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 224
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&total_fee=\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 225
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&notify_url=\"http://platform.xxxy.dayukeji.com:9999/Payment/payment/alipaycallback\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 227
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&service=\"mobile.securitypay.pay\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 228
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&payment_type=\"1\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 229
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&_input_charset=\"utf-8\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 230
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&it_b_pay=\"30m\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 232
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "&return_url=\"m.alipay.com\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 283
    return-object v0
.end method

.method public getOutTradeNo()Ljava/lang/String;
    .locals 1

    .prologue
    .line 292
    sget-object v0, Lcom/dygame/open/dayu/DYAlipayHelper;->mAppOrderId:Ljava/lang/String;

    return-object v0
.end method

.method public getSDKVersion()V
    .locals 4

    .prologue
    .line 208
    new-instance v0, Lcom/alipay/sdk/app/PayTask;

    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-direct {v0, v2}, Lcom/alipay/sdk/app/PayTask;-><init>(Landroid/app/Activity;)V

    .line 209
    .local v0, "payTask":Lcom/alipay/sdk/app/PayTask;
    invoke-virtual {v0}, Lcom/alipay/sdk/app/PayTask;->getVersion()Ljava/lang/String;

    move-result-object v1

    .line 210
    .local v1, "version":Ljava/lang/String;
    sget-object v2, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const/4 v3, 0x0

    invoke-static {v2, v1, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 211
    return-void
.end method

.method public getSignType()Ljava/lang/String;
    .locals 1

    .prologue
    .line 310
    const-string v0, "sign_type=\"RSA\""

    return-object v0
.end method

.method public pay(Ljava/lang/String;)V
    .locals 16
    .param p1, "strParam"    # Ljava/lang/String;

    .prologue
    .line 95
    const/4 v3, 0x0

    .line 97
    .local v3, "jObj":Lorg/json/JSONObject;
    :try_start_0
    new-instance v4, Lorg/json/JSONObject;

    move-object/from16 v0, p1

    invoke-direct {v4, v0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 106
    .end local v3    # "jObj":Lorg/json/JSONObject;
    .local v4, "jObj":Lorg/json/JSONObject;
    const-string v13, "2088002219936822"

    invoke-static {v13}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v13

    if-nez v13, :cond_0

    const-string v13, "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAM3IygQphzm/sehvqC9YOm7Uz8JqqP3e5wu2JO8EHQj/oI3f/QKsyMdtU+P54SR0FwjFWPvfCG+7rOh2K5UAqaHWa5cpYKHO6oYYHcsDahvSRQpPp+Ckj5ZrK+2TXZu7gr/VoZ3WNaLtNBL3Fn6mzpIz0G4jH+tl6wlFP9uAFlCrAgMBAAECgYEArWrhe8J3d94pEmVOSZ/DlnT3JLL3+QGomcEEvPwtb9Dkv8scD+4GQbHLeZqx9iNy6exNgezB0k9JdplnPulRCVLhcVlrc6xRfPQIewQ7Eb3s7QPortXQkOS6nF93txrBM5Et24Qwg8b6YztQFjyilnUc0wr399mYCaUOySMmcHECQQD0s5Fbs/zYAobei6MTr6YP0qs73HHOmEOsGpuEJmegjB2fS3dL+z30uyu7lehyGzDI3+x9dm3pCT/BZ+q0UUgZAkEA10k2HzIEvl6Qt9xe5dwJsFahNYpoAXrdFEsonraSo5TLx4UNJwnQA8IicJfJycViJsgRXSciTieTBvouJfzHYwJBAO+Mfoc0exiH2LoyHrId6MZiqQjP9IWX39+yqH3FDvtHT5Rqz12Nlghn1xcrWMOjxK1RMPVdo5lXWZefgE+HprkCQQC+7L2j0s8kKWd8t2ItxgONsHZNrk5oqZaxLap7fvzzN721V0j/yxMAkkXKxsJ9P6C5Ngs4KsGgwDYDJRKSO+hzAkBAEnx73hiMyQiFpTMiDMZgSg3kJhfjIp57Yyn6nTh6F6l7y8fqlOz3FPYeToeUJr6c6ovKl27MIwYuPXdpOC5/"

    invoke-static {v13}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v13

    if-nez v13, :cond_0

    const-string v13, "kuangpanfeng@163.com"

    .line 107
    invoke-static {v13}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v13

    if-eqz v13, :cond_1

    .line 108
    :cond_0
    new-instance v13, Landroid/app/AlertDialog$Builder;

    sget-object v14, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-direct {v13, v14}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v14, "\u8b66\u544a"

    .line 109
    invoke-virtual {v13, v14}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v13

    const-string v14, "\u9700\u8981\u914d\u7f6ePARTNER | RSA_PRIVATE| SELLER"

    .line 110
    invoke-virtual {v13, v14}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v13

    const-string v14, "\u786e\u5b9a"

    new-instance v15, Lcom/dygame/open/dayu/DYAlipayHelper$2;

    invoke-direct/range {v15 .. v16}, Lcom/dygame/open/dayu/DYAlipayHelper$2;-><init>(Lcom/dygame/open/dayu/DYAlipayHelper;)V

    .line 111
    invoke-virtual {v13, v14, v15}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v13

    .line 116
    invoke-virtual {v13}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    move-object v3, v4

    .line 174
    .end local v4    # "jObj":Lorg/json/JSONObject;
    .restart local v3    # "jObj":Lorg/json/JSONObject;
    :goto_0
    return-void

    .line 98
    :catch_0
    move-exception v2

    .line 100
    .local v2, "e1":Lorg/json/JSONException;
    invoke-virtual {v2}, Lorg/json/JSONException;->printStackTrace()V

    .line 102
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v13

    const/4 v14, 0x0

    invoke-virtual {v13, v14}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    goto :goto_0

    .line 121
    .end local v2    # "e1":Lorg/json/JSONException;
    .end local v3    # "jObj":Lorg/json/JSONObject;
    .restart local v4    # "jObj":Lorg/json/JSONObject;
    :cond_1
    const-string v13, "name"

    const-string v14, ""

    invoke-virtual {v4, v13, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 122
    .local v7, "pName":Ljava/lang/String;
    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v13

    if-nez v13, :cond_2

    .line 123
    const-string v7, "\u5927\u79b9\u6e38\u620f\u865a\u62df\u5546\u54c1"

    .line 125
    :cond_2
    const-string v13, "desc"

    const-string v14, ""

    invoke-virtual {v4, v13, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 126
    .local v6, "pDesc":Ljava/lang/String;
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v13

    if-nez v13, :cond_3

    .line 127
    move-object v6, v7

    .line 129
    :cond_3
    const-string v13, "price"

    const-string v14, "0.01"

    invoke-virtual {v4, v13, v14}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 131
    .local v8, "pPrice":Ljava/lang/String;
    const-string v13, "orderId"

    invoke-virtual {v4, v13}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    sput-object v13, Lcom/dygame/open/dayu/DYAlipayHelper;->mAppOrderId:Ljava/lang/String;

    .line 133
    move-object/from16 v0, p0

    invoke-virtual {v0, v7, v6, v8}, Lcom/dygame/open/dayu/DYAlipayHelper;->getOrderInfo(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 136
    .local v5, "orderInfo":Ljava/lang/String;
    move-object/from16 v0, p0

    invoke-virtual {v0, v5}, Lcom/dygame/open/dayu/DYAlipayHelper;->sign(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 137
    .local v12, "sign":Ljava/lang/String;
    if-nez v12, :cond_4

    .line 138
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v13

    const/4 v14, 0x0

    invoke-virtual {v13, v14}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    move-object v3, v4

    .line 139
    .end local v4    # "jObj":Lorg/json/JSONObject;
    .restart local v3    # "jObj":Lorg/json/JSONObject;
    goto :goto_0

    .line 144
    .end local v3    # "jObj":Lorg/json/JSONObject;
    .restart local v4    # "jObj":Lorg/json/JSONObject;
    :cond_4
    :try_start_1
    const-string v13, "UTF-8"

    invoke-static {v12, v13}, Ljava/net/URLEncoder;->encode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v12

    .line 152
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v13, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    const-string v14, "&sign=\""

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    const-string v14, "\"&"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    .line 153
    invoke-virtual/range {p0 .. p0}, Lcom/dygame/open/dayu/DYAlipayHelper;->getSignType()Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    .line 155
    .local v9, "payInfo":Ljava/lang/String;
    new-instance v10, Lcom/dygame/open/dayu/DYAlipayHelper$3;

    move-object/from16 v0, p0

    invoke-direct {v10, v0, v9}, Lcom/dygame/open/dayu/DYAlipayHelper$3;-><init>(Lcom/dygame/open/dayu/DYAlipayHelper;Ljava/lang/String;)V

    .line 172
    .local v10, "payRunnable":Ljava/lang/Runnable;
    new-instance v11, Ljava/lang/Thread;

    invoke-direct {v11, v10}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 173
    .local v11, "payThread":Ljava/lang/Thread;
    invoke-virtual {v11}, Ljava/lang/Thread;->start()V

    move-object v3, v4

    .line 174
    .end local v4    # "jObj":Lorg/json/JSONObject;
    .restart local v3    # "jObj":Lorg/json/JSONObject;
    goto/16 :goto_0

    .line 145
    .end local v3    # "jObj":Lorg/json/JSONObject;
    .end local v9    # "payInfo":Ljava/lang/String;
    .end local v10    # "payRunnable":Ljava/lang/Runnable;
    .end local v11    # "payThread":Ljava/lang/Thread;
    .restart local v4    # "jObj":Lorg/json/JSONObject;
    :catch_1
    move-exception v1

    .line 146
    .local v1, "e":Ljava/io/UnsupportedEncodingException;
    invoke-virtual {v1}, Ljava/io/UnsupportedEncodingException;->printStackTrace()V

    .line 147
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v13

    const/4 v14, 0x0

    invoke-virtual {v13, v14}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    move-object v3, v4

    .line 148
    .end local v4    # "jObj":Lorg/json/JSONObject;
    .restart local v3    # "jObj":Lorg/json/JSONObject;
    goto/16 :goto_0
.end method

.method public sign(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p1, "content"    # Ljava/lang/String;

    .prologue
    .line 302
    const-string v0, "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAM3IygQphzm/sehvqC9YOm7Uz8JqqP3e5wu2JO8EHQj/oI3f/QKsyMdtU+P54SR0FwjFWPvfCG+7rOh2K5UAqaHWa5cpYKHO6oYYHcsDahvSRQpPp+Ckj5ZrK+2TXZu7gr/VoZ3WNaLtNBL3Fn6mzpIz0G4jH+tl6wlFP9uAFlCrAgMBAAECgYEArWrhe8J3d94pEmVOSZ/DlnT3JLL3+QGomcEEvPwtb9Dkv8scD+4GQbHLeZqx9iNy6exNgezB0k9JdplnPulRCVLhcVlrc6xRfPQIewQ7Eb3s7QPortXQkOS6nF93txrBM5Et24Qwg8b6YztQFjyilnUc0wr399mYCaUOySMmcHECQQD0s5Fbs/zYAobei6MTr6YP0qs73HHOmEOsGpuEJmegjB2fS3dL+z30uyu7lehyGzDI3+x9dm3pCT/BZ+q0UUgZAkEA10k2HzIEvl6Qt9xe5dwJsFahNYpoAXrdFEsonraSo5TLx4UNJwnQA8IicJfJycViJsgRXSciTieTBvouJfzHYwJBAO+Mfoc0exiH2LoyHrId6MZiqQjP9IWX39+yqH3FDvtHT5Rqz12Nlghn1xcrWMOjxK1RMPVdo5lXWZefgE+HprkCQQC+7L2j0s8kKWd8t2ItxgONsHZNrk5oqZaxLap7fvzzN721V0j/yxMAkkXKxsJ9P6C5Ngs4KsGgwDYDJRKSO+hzAkBAEnx73hiMyQiFpTMiDMZgSg3kJhfjIp57Yyn6nTh6F6l7y8fqlOz3FPYeToeUJr6c6ovKl27MIwYuPXdpOC5/"

    invoke-static {p1, v0}, Lcom/dygame/open/dayu/SignUtils;->sign(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
