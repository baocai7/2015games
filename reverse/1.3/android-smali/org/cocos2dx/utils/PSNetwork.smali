.class public Lorg/cocos2dx/utils/PSNetwork;
.super Ljava/lang/Object;
.source "PSNetwork.java"


# static fields
.field static mConnManager:Landroid/net/ConnectivityManager;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 11
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/utils/PSNetwork;->mConnManager:Landroid/net/ConnectivityManager;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getInternetConnectionStatus()I
    .locals 1

    .prologue
    .line 68
    invoke-static {}, Lorg/cocos2dx/utils/PSNetwork;->isLocalWiFiAvailable()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 69
    const/4 v0, 0x1

    .line 74
    :goto_0
    return v0

    .line 71
    :cond_0
    invoke-static {}, Lorg/cocos2dx/utils/PSNetwork;->isInternetConnectionAvailable()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 72
    const/4 v0, 0x2

    goto :goto_0

    .line 74
    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static init(Landroid/content/Context;)V
    .locals 1
    .param p0, "context"    # Landroid/content/Context;

    .prologue
    .line 14
    const-string v0, "connectivity"

    .line 15
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/ConnectivityManager;

    sput-object v0, Lorg/cocos2dx/utils/PSNetwork;->mConnManager:Landroid/net/ConnectivityManager;

    .line 16
    return-void
.end method

.method public static isHostNameReachable(Ljava/lang/String;)Z
    .locals 6
    .param p0, "hostName"    # Ljava/lang/String;

    .prologue
    const/4 v5, 0x0

    .line 46
    const/4 v0, 0x0

    .line 47
    .local v0, "counts":I
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-gtz v4, :cond_1

    :cond_0
    move v4, v5

    .line 64
    :goto_0
    return v4

    .line 59
    :catch_0
    move-exception v1

    .line 60
    .local v1, "ex":Ljava/lang/Exception;
    add-int/lit8 v0, v0, 0x1

    .line 50
    .end local v1    # "ex":Ljava/lang/Exception;
    :cond_1
    const/4 v4, 0x3

    if-ge v0, v4, :cond_3

    .line 52
    :try_start_0
    new-instance v3, Ljava/net/URL;

    invoke-direct {v3, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    .line 53
    .local v3, "url":Ljava/net/URL;
    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v4

    check-cast v4, Ljava/net/HttpURLConnection;

    .line 54
    invoke-virtual {v4}, Ljava/net/HttpURLConnection;->getResponseCode()I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v2

    .line 55
    .local v2, "state":I
    const/16 v4, 0xc8

    if-ne v2, v4, :cond_2

    .line 56
    const/4 v4, 0x1

    goto :goto_0

    :cond_2
    move v4, v5

    .line 58
    goto :goto_0

    .end local v2    # "state":I
    .end local v3    # "url":Ljava/net/URL;
    :cond_3
    move v4, v5

    .line 64
    goto :goto_0
.end method

.method public static isInternetConnectionAvailable()Z
    .locals 6

    .prologue
    const/4 v2, 0x1

    const/4 v3, 0x0

    .line 28
    sget-object v4, Lorg/cocos2dx/utils/PSNetwork;->mConnManager:Landroid/net/ConnectivityManager;

    if-nez v4, :cond_0

    .line 41
    .local v1, "state":Landroid/net/NetworkInfo$State;
    :goto_0
    return v3

    .line 32
    .end local v1    # "state":Landroid/net/NetworkInfo$State;
    :cond_0
    invoke-static {}, Lorg/cocos2dx/utils/PSNetwork;->isLocalWiFiAvailable()Z

    move-result v4

    if-eqz v4, :cond_1

    move v3, v2

    .line 33
    goto :goto_0

    .line 37
    :cond_1
    :try_start_0
    sget-object v4, Lorg/cocos2dx/utils/PSNetwork;->mConnManager:Landroid/net/ConnectivityManager;

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/net/ConnectivityManager;->getNetworkInfo(I)Landroid/net/NetworkInfo;

    move-result-object v4

    .line 38
    invoke-virtual {v4}, Landroid/net/NetworkInfo;->getState()Landroid/net/NetworkInfo$State;

    move-result-object v1

    .line 39
    .restart local v1    # "state":Landroid/net/NetworkInfo$State;
    sget-object v4, Landroid/net/NetworkInfo$State;->CONNECTED:Landroid/net/NetworkInfo$State;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-ne v4, v1, :cond_2

    :goto_1
    move v3, v2

    goto :goto_0

    :cond_2
    move v2, v3

    goto :goto_1

    .line 40
    :catch_0
    move-exception v0

    .line 41
    .local v0, "e":Ljava/lang/Exception;
    goto :goto_0
.end method

.method public static isLocalWiFiAvailable()Z
    .locals 4

    .prologue
    const/4 v1, 0x1

    const/4 v2, 0x0

    .line 19
    sget-object v3, Lorg/cocos2dx/utils/PSNetwork;->mConnManager:Landroid/net/ConnectivityManager;

    if-nez v3, :cond_0

    .line 24
    .local v0, "state":Landroid/net/NetworkInfo$State;
    :goto_0
    return v2

    .line 22
    .end local v0    # "state":Landroid/net/NetworkInfo$State;
    :cond_0
    sget-object v3, Lorg/cocos2dx/utils/PSNetwork;->mConnManager:Landroid/net/ConnectivityManager;

    .line 23
    invoke-virtual {v3, v1}, Landroid/net/ConnectivityManager;->getNetworkInfo(I)Landroid/net/NetworkInfo;

    move-result-object v3

    invoke-virtual {v3}, Landroid/net/NetworkInfo;->getState()Landroid/net/NetworkInfo$State;

    move-result-object v0

    .line 24
    .restart local v0    # "state":Landroid/net/NetworkInfo$State;
    sget-object v3, Landroid/net/NetworkInfo$State;->CONNECTED:Landroid/net/NetworkInfo$State;

    if-ne v3, v0, :cond_1

    :goto_1
    move v2, v1

    goto :goto_0

    :cond_1
    move v1, v2

    goto :goto_1
.end method
