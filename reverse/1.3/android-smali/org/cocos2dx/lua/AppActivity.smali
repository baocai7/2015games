.class public Lorg/cocos2dx/lua/AppActivity;
.super Lorg/cocos2dx/lib/Cocos2dxActivity;
.source "AppActivity.java"


# static fields
.field static hostIPAdress:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 49
    const-string v0, "0.0.0.0"

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->hostIPAdress:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 47
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;-><init>()V

    return-void
.end method

.method public static getLocalIpAddress()Ljava/lang/String;
    .locals 1

    .prologue
    .line 118
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->hostIPAdress:Ljava/lang/String;

    return-object v0
.end method

.method private isNetworkConnected()Z
    .locals 7

    .prologue
    const/4 v4, 0x1

    .line 90
    const-string v5, "connectivity"

    invoke-virtual {p0, v5}, Lorg/cocos2dx/lua/AppActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/ConnectivityManager;

    .line 91
    .local v0, "cm":Landroid/net/ConnectivityManager;
    if-eqz v0, :cond_0

    .line 92
    invoke-virtual {v0}, Landroid/net/ConnectivityManager;->getActiveNetworkInfo()Landroid/net/NetworkInfo;

    move-result-object v2

    .line 94
    .local v2, "networkInfo":Landroid/net/NetworkInfo;
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 95
    .local v3, "networkTypes":Ljava/util/ArrayList;
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 97
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

    .line 103
    :goto_0
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/net/NetworkInfo;->getType()I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 107
    .end local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .end local v3    # "networkTypes":Ljava/util/ArrayList;
    :goto_1
    return v4

    .line 100
    .restart local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .restart local v3    # "networkTypes":Ljava/util/ArrayList;
    :catch_0
    move-exception v1

    .line 101
    .local v1, "iae":Ljava/lang/IllegalAccessException;
    new-instance v4, Ljava/lang/RuntimeException;

    invoke-direct {v4, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v4

    .line 107
    .end local v1    # "iae":Ljava/lang/IllegalAccessException;
    .end local v2    # "networkInfo":Landroid/net/NetworkInfo;
    .end local v3    # "networkTypes":Ljava/util/ArrayList;
    :cond_0
    const/4 v4, 0x0

    goto :goto_1

    .line 98
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


# virtual methods
.method public getHostIpAddress()Ljava/lang/String;
    .locals 5

    .prologue
    .line 111
    const-string v3, "wifi"

    invoke-virtual {p0, v3}, Lorg/cocos2dx/lua/AppActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/wifi/WifiManager;

    .line 112
    .local v2, "wifiMgr":Landroid/net/wifi/WifiManager;
    invoke-virtual {v2}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v1

    .line 113
    .local v1, "wifiInfo":Landroid/net/wifi/WifiInfo;
    invoke-virtual {v1}, Landroid/net/wifi/WifiInfo;->getIpAddress()I

    move-result v0

    .line 114
    .local v0, "ip":I
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

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
    .locals 3
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    const/16 v2, 0x80

    .line 52
    invoke-super {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onCreate(Landroid/os/Bundle;)V

    .line 54
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->nativeIsLandScape()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 55
    const/4 v1, 0x6

    invoke-virtual {p0, v1}, Lorg/cocos2dx/lua/AppActivity;->setRequestedOrientation(I)V

    .line 63
    :goto_0
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->nativeIsDebug()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 65
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1, v2, v2}, Landroid/view/Window;->setFlags(II)V

    .line 66
    invoke-direct {p0}, Lorg/cocos2dx/lua/AppActivity;->isNetworkConnected()Z

    move-result v1

    if-nez v1, :cond_0

    .line 68
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 69
    .local v0, "builder":Landroid/app/AlertDialog$Builder;
    const-string v1, "Warning"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 70
    const-string v1, "Please open WIFI for debuging..."

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    .line 71
    const-string v1, "OK"

    new-instance v2, Lorg/cocos2dx/lua/AppActivity$1;

    invoke-direct {v2, p0}, Lorg/cocos2dx/lua/AppActivity$1;-><init>(Lorg/cocos2dx/lua/AppActivity;)V

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    .line 81
    const-string v1, "Cancel"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    .line 82
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    .line 83
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 86
    .end local v0    # "builder":Landroid/app/AlertDialog$Builder;
    :cond_0
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getHostIpAddress()Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lorg/cocos2dx/lua/AppActivity;->hostIPAdress:Ljava/lang/String;

    .line 87
    return-void

    .line 57
    :cond_1
    const/4 v1, 0x7

    invoke-virtual {p0, v1}, Lorg/cocos2dx/lua/AppActivity;->setRequestedOrientation(I)V

    goto :goto_0
.end method
