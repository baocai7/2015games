.class public Lorg/cocos2dx/utils/PSNative;
.super Ljava/lang/Object;
.source "PSNative.java"


# static fields
.field static mAppIcon:Landroid/graphics/drawable/Drawable;

.field static mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

.field static mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

.field static mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

.field static mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

.field static mShowingDialogs:Ljava/util/Vector;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Vector",
            "<",
            "Lorg/cocos2dx/utils/PSDialog;",
            ">;"
        }
    .end annotation
.end field

.field static mTelephonyManager:Landroid/telephony/TelephonyManager;

.field static mVibrator:Landroid/os/Vibrator;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    const/4 v0, 0x0

    .line 18
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 19
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 20
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mVibrator:Landroid/os/Vibrator;

    .line 22
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 23
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 24
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    .line 26
    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mAppIcon:Landroid/graphics/drawable/Drawable;

    .line 28
    new-instance v0, Lorg/cocos2dx/utils/PSNative$1;

    invoke-direct {v0}, Lorg/cocos2dx/utils/PSNative$1;-><init>()V

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static addAlertButton(Ljava/lang/String;)I
    .locals 1
    .param p0, "buttonTitle"    # Ljava/lang/String;

    .prologue
    .line 113
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-nez v0, :cond_0

    .line 114
    const/4 v0, 0x0

    .line 116
    :goto_0
    return v0

    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/utils/PSDialog;->addAlertButton(Ljava/lang/String;)I

    move-result v0

    goto :goto_0
.end method

.method public static cancelAlert()V
    .locals 2

    .prologue
    .line 154
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-nez v0, :cond_0

    .line 164
    :goto_0
    return-void

    .line 157
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/utils/PSNative$6;

    invoke-direct {v1}, Lorg/cocos2dx/utils/PSNative$6;-><init>()V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static createAlert(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 2
    .param p0, "title"    # Ljava/lang/String;
    .param p1, "message"    # Ljava/lang/String;
    .param p2, "defalutButtonTitle"    # Ljava/lang/String;
    .param p3, "listener"    # I
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .prologue
    .line 86
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    if-nez v0, :cond_0

    .line 110
    :goto_0
    return-void

    .line 90
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/utils/PSNative$3;

    invoke-direct {v1, p1, p0, p3, p2}, Lorg/cocos2dx/utils/PSNative$3;-><init>(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static createAlert(Ljava/lang/String;Ljava/lang/String;Ljava/util/Vector;I)V
    .locals 2
    .param p0, "title"    # Ljava/lang/String;
    .param p1, "message"    # Ljava/lang/String;
    .param p3, "listener"    # I
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/util/Vector",
            "<",
            "Ljava/lang/String;",
            ">;I)V"
        }
    .end annotation

    .prologue
    .line 52
    .local p2, "buttonTitles":Ljava/util/Vector;, "Ljava/util/Vector<Ljava/lang/String;>;"
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    if-nez v0, :cond_0

    .line 78
    :goto_0
    return-void

    .line 56
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/utils/PSNative$2;

    invoke-direct {v1, p1, p0, p3, p2}, Lorg/cocos2dx/utils/PSNative$2;-><init>(Ljava/lang/String;Ljava/lang/String;ILjava/util/Vector;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static getAppContext()Landroid/content/Context;
    .locals 1

    .prologue
    .line 231
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    return-object v0
.end method

.method public static getDeviceName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 213
    sget-object v0, Landroid/os/Build;->USER:Ljava/lang/String;

    return-object v0
.end method

.method public static getInputText(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "title"    # Ljava/lang/String;
    .param p1, "message"    # Ljava/lang/String;
    .param p2, "defaultValue"    # Ljava/lang/String;

    .prologue
    .line 186
    const-string v0, ""

    return-object v0
.end method

.method private static getMacAddress()Ljava/lang/String;
    .locals 4

    .prologue
    .line 190
    sget-object v2, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    const-string v3, "wifi"

    .line 191
    invoke-virtual {v2, v3}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/net/wifi/WifiManager;

    .line 192
    .local v1, "wifi":Landroid/net/wifi/WifiManager;
    invoke-virtual {v1}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v0

    .line 193
    .local v0, "info":Landroid/net/wifi/WifiInfo;
    if-nez v0, :cond_0

    .line 194
    const/4 v2, 0x0

    .line 195
    :goto_0
    return-object v2

    :cond_0
    invoke-virtual {v0}, Landroid/net/wifi/WifiInfo;->getMacAddress()Ljava/lang/String;

    move-result-object v2

    goto :goto_0
.end method

.method public static getOpenUDID()Ljava/lang/String;
    .locals 2

    .prologue
    .line 199
    const/4 v0, 0x0

    .line 200
    .local v0, "id":Ljava/lang/String;
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    if-eqz v1, :cond_0

    .line 201
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {v1}, Landroid/telephony/TelephonyManager;->getDeviceId()Ljava/lang/String;

    move-result-object v0

    .line 203
    :cond_0
    if-nez v0, :cond_1

    .line 204
    invoke-static {}, Lorg/cocos2dx/utils/PSNative;->getMacAddress()Ljava/lang/String;

    move-result-object v0

    .line 206
    :cond_1
    if-nez v0, :cond_2

    .line 207
    const-string v0, ""

    .line 209
    :cond_2
    return-object v0
.end method

.method public static init(Lorg/cocos2dx/lib/Cocos2dxActivity;)V
    .locals 1
    .param p0, "context"    # Lorg/cocos2dx/lib/Cocos2dxActivity;

    .prologue
    .line 36
    sput-object p0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 37
    const-string v0, "phone"

    .line 38
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 39
    const-string v0, "vibrator"

    .line 40
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Vibrator;

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mVibrator:Landroid/os/Vibrator;

    .line 42
    new-instance v0, Ljava/util/Vector;

    invoke-direct {v0}, Ljava/util/Vector;-><init>()V

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    .line 43
    return-void
.end method

.method public static openURL(Ljava/lang/String;)V
    .locals 4
    .param p0, "url"    # Ljava/lang/String;

    .prologue
    .line 177
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    if-nez v1, :cond_0

    .line 182
    :goto_0
    return-void

    .line 180
    :cond_0
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 181
    .local v0, "uri":Landroid/net/Uri;
    sget-object v1, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.intent.action.VIEW"

    invoke-direct {v2, v3, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxActivity;->startActivity(Landroid/content/Intent;)V

    goto :goto_0
.end method

.method public static setAppIcon(Landroid/graphics/drawable/Drawable;)V
    .locals 0
    .param p0, "icon"    # Landroid/graphics/drawable/Drawable;

    .prologue
    .line 47
    sput-object p0, Lorg/cocos2dx/utils/PSNative;->mAppIcon:Landroid/graphics/drawable/Drawable;

    .line 48
    return-void
.end method

.method public static showAlert()V
    .locals 2

    .prologue
    .line 120
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-nez v0, :cond_0

    .line 137
    :goto_0
    return-void

    .line 124
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/utils/PSNative$4;

    invoke-direct {v1}, Lorg/cocos2dx/utils/PSNative$4;-><init>()V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static showAlertLua(I)V
    .locals 2
    .param p0, "luaFunctionId"    # I

    .prologue
    .line 140
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mCreatingDialog:Lorg/cocos2dx/utils/PSDialog;

    if-nez v0, :cond_0

    .line 151
    :goto_0
    return-void

    .line 144
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/utils/PSNative$5;

    invoke-direct {v1, p0}, Lorg/cocos2dx/utils/PSNative$5;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnGLThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static showPreAlert()V
    .locals 2

    .prologue
    .line 167
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    invoke-virtual {v0}, Ljava/util/Vector;->size()I

    move-result v0

    if-lez v0, :cond_0

    .line 168
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    invoke-virtual {v0}, Ljava/util/Vector;->firstElement()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/utils/PSDialog;

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    .line 169
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialogs:Ljava/util/Vector;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/Vector;->remove(I)Ljava/lang/Object;

    .line 170
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->show()V

    .line 174
    :goto_0
    return-void

    .line 172
    :cond_0
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/utils/PSNative;->mShowingDialog:Lorg/cocos2dx/utils/PSDialog;

    goto :goto_0
.end method

.method public static vibrate(J)V
    .locals 2
    .param p0, "time"    # J

    .prologue
    .line 217
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mVibrator:Landroid/os/Vibrator;

    if-nez v0, :cond_0

    .line 221
    :goto_0
    return-void

    .line 220
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mVibrator:Landroid/os/Vibrator;

    invoke-virtual {v0, p0, p1}, Landroid/os/Vibrator;->vibrate(J)V

    goto :goto_0
.end method

.method public static vibrate([JI)V
    .locals 1
    .param p0, "pattern"    # [J
    .param p1, "repeatcout"    # I

    .prologue
    .line 224
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mVibrator:Landroid/os/Vibrator;

    if-nez v0, :cond_0

    .line 228
    :goto_0
    return-void

    .line 227
    :cond_0
    sget-object v0, Lorg/cocos2dx/utils/PSNative;->mVibrator:Landroid/os/Vibrator;

    invoke-virtual {v0, p0, p1}, Landroid/os/Vibrator;->vibrate([JI)V

    goto :goto_0
.end method
