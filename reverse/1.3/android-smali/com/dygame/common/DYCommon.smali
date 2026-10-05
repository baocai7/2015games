.class public Lcom/dygame/common/DYCommon;
.super Ljava/lang/Object;
.source "DYCommon.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;
    }
.end annotation


# static fields
.field private static mCommonHandler:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 114
    invoke-static {}, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->getInstance()Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    move-result-object v0

    sput-object v0, Lcom/dygame/common/DYCommon;->mCommonHandler:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    .line 113
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 117
    return-void
.end method

.method public static MAC()Ljava/lang/String;
    .locals 5

    .prologue
    .line 53
    const-string v2, ""

    .line 54
    .local v2, "macAddress":Ljava/lang/String;
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    .line 55
    .local v0, "act":Lcom/dygame/common/DYGame;
    const-string v4, "wifi"

    .line 56
    invoke-virtual {v0, v4}, Lcom/dygame/common/DYGame;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/net/wifi/WifiManager;

    .line 57
    .local v3, "wifiMgr":Landroid/net/wifi/WifiManager;
    if-nez v3, :cond_1

    const/4 v1, 0x0

    .line 58
    .local v1, "info":Landroid/net/wifi/WifiInfo;
    :goto_0
    if-eqz v1, :cond_0

    .line 59
    invoke-virtual {v1}, Landroid/net/wifi/WifiInfo;->getMacAddress()Ljava/lang/String;

    move-result-object v2

    .line 61
    :cond_0
    return-object v2

    .line 57
    .end local v1    # "info":Landroid/net/wifi/WifiInfo;
    :cond_1
    invoke-virtual {v3}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v1

    goto :goto_0
.end method

.method public static channelName(Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    .line 25
    sget-object v4, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-virtual {v4}, Lcom/dygame/common/DYGame;->getApplication()Landroid/app/Application;

    move-result-object v2

    .line 27
    .local v2, "context":Landroid/content/Context;
    const-string v1, "300007"

    .line 29
    .local v1, "channel":Ljava/lang/String;
    :try_start_0
    invoke-virtual {v2}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v4

    .line 30
    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v5

    const/16 v6, 0x80

    invoke-virtual {v4, v5, v6}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    .line 32
    .local v0, "appInfo":Landroid/content/pm/ApplicationInfo;
    iget-object v4, v0, Landroid/content/pm/ApplicationInfo;->metaData:Landroid/os/Bundle;

    const-string v5, "DAYU_CHANNEL"

    invoke-virtual {v4, v5}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 35
    const/4 v4, 0x2

    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v1

    .line 41
    .end local v0    # "appInfo":Landroid/content/pm/ApplicationInfo;
    :goto_0
    return-object v1

    .line 36
    :catch_0
    move-exception v3

    .line 38
    .local v3, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    invoke-virtual {v3}, Landroid/content/pm/PackageManager$NameNotFoundException;->printStackTrace()V

    goto :goto_0
.end method

.method public static doNotify(Ljava/lang/String;)V
    .locals 6
    .param p0, "content"    # Ljava/lang/String;

    .prologue
    const/4 v5, -0x1

    .line 97
    const/4 v2, -0x1

    .line 98
    .local v2, "listener":I
    const/4 v0, 0x0

    .line 100
    .local v0, "jObj":Lorg/json/JSONObject;
    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 101
    .end local v0    # "jObj":Lorg/json/JSONObject;
    .local v1, "jObj":Lorg/json/JSONObject;
    :try_start_1
    const-string v3, "listener"

    const/4 v4, -0x1

    invoke-virtual {v1, v3, v4}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v2

    .line 102
    const-string v3, "listener"

    invoke-virtual {v1, v3}, Lorg/json/JSONObject;->remove(Ljava/lang/String;)Ljava/lang/Object;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-object v0, v1

    .line 107
    .end local v1    # "jObj":Lorg/json/JSONObject;
    .restart local v0    # "jObj":Lorg/json/JSONObject;
    :goto_0
    if-eq v2, v5, :cond_0

    .line 109
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v3

    .line 108
    invoke-static {v2, v3}, Lorg/cocos2dx/lib/Cocos2dxLuaJavaBridge;->callLuaFunctionWithString(ILjava/lang/String;)I

    .line 111
    :cond_0
    return-void

    .line 103
    :catch_0
    move-exception v3

    goto :goto_0

    .end local v0    # "jObj":Lorg/json/JSONObject;
    .restart local v1    # "jObj":Lorg/json/JSONObject;
    :catch_1
    move-exception v3

    move-object v0, v1

    .end local v1    # "jObj":Lorg/json/JSONObject;
    .restart local v0    # "jObj":Lorg/json/JSONObject;
    goto :goto_0
.end method

.method public static native gameMode()Ljava/lang/String;
.end method

.method public static native gameVer()Ljava/lang/String;
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .prologue
    .line 70
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    return-object v0
.end method

.method public static gotoLink(Ljava/lang/String;)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;

    .prologue
    .line 45
    sget-object v0, Lcom/dygame/common/DYCommon;->mCommonHandler:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    invoke-virtual {v0, p0}, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->tryGotoLink(Ljava/lang/String;)V

    .line 46
    return-void
.end method

.method public static hideLoading()V
    .locals 3

    .prologue
    .line 49
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const-string v1, "doHideLoading"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcom/dygame/common/DYThreadHelper;->runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 50
    return-void
.end method

.method public static isSupportShare()Ljava/lang/String;
    .locals 1

    .prologue
    .line 65
    const-string v0, "true"

    return-object v0
.end method

.method public static notifyScriptListener(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 5
    .param p0, "event"    # Ljava/lang/String;
    .param p1, "param"    # Ljava/lang/String;
    .param p2, "listener"    # I

    .prologue
    .line 76
    const/4 v2, -0x1

    if-eq p2, v2, :cond_2

    .line 77
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    .line 79
    .local v1, "jObj":Lorg/json/JSONObject;
    if-eqz p1, :cond_0

    :try_start_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    if-gtz v2, :cond_1

    .line 80
    :cond_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    .line 83
    :cond_1
    const-string v2, "event"

    invoke-virtual {v1, v2, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 84
    const-string v2, "param"

    invoke-virtual {v1, v2, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 85
    const-string v2, "listener"

    invoke-virtual {v1, v2, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 91
    :goto_0
    const-class v2, Lcom/dygame/common/DYCommon;

    const-string v3, "doNotify"

    .line 92
    invoke-virtual {v1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v4

    .line 91
    invoke-static {v2, v3, v4}, Lcom/dygame/common/DYThreadHelper;->runStaticFunctionOnGLThread(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V

    .line 94
    .end local v1    # "jObj":Lorg/json/JSONObject;
    :cond_2
    return-void

    .line 86
    .restart local v1    # "jObj":Lorg/json/JSONObject;
    :catch_0
    move-exception v0

    .line 88
    .local v0, "e":Lorg/json/JSONException;
    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    goto :goto_0
.end method

.method public static tryQuit(Ljava/lang/String;I)V
    .locals 1
    .param p0, "param"    # Ljava/lang/String;
    .param p1, "listener"    # I

    .prologue
    .line 21
    sget-object v0, Lcom/dygame/common/DYCommon;->mCommonHandler:Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;

    invoke-virtual {v0, p0, p1}, Lcom/dygame/common/DYCommon$DYCommonHandlerDemo;->tryQuit(Ljava/lang/String;I)V

    .line 22
    return-void
.end method
