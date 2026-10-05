.class public Lcom/dygame/dysdk/DYSdkHelper;
.super Ljava/lang/Object;
.source "DYSdkHelper.java"


# static fields
.field static final synthetic $assertionsDisabled:Z

.field protected static mLoginContext:Landroid/app/Activity;

.field protected static mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

.field protected static mPayContext:Landroid/app/Activity;

.field protected static mPayListener:Lcom/dygame/dysdk/DYSdkPayListener;

.field private static mPrefs:Landroid/content/SharedPreferences;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 14
    const-class v0, Lcom/dygame/dysdk/DYSdkHelper;

    invoke-virtual {v0}, Ljava/lang/Class;->desiredAssertionStatus()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    sput-boolean v0, Lcom/dygame/dysdk/DYSdkHelper;->$assertionsDisabled:Z

    .line 15
    sput-object v1, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    .line 16
    sput-object v1, Lcom/dygame/dysdk/DYSdkHelper;->mLoginContext:Landroid/app/Activity;

    .line 17
    sput-object v1, Lcom/dygame/dysdk/DYSdkHelper;->mPayContext:Landroid/app/Activity;

    .line 18
    sput-object v1, Lcom/dygame/dysdk/DYSdkHelper;->mPrefs:Landroid/content/SharedPreferences;

    .line 19
    sput-object v1, Lcom/dygame/dysdk/DYSdkHelper;->mPayListener:Lcom/dygame/dysdk/DYSdkPayListener;

    return-void

    .line 14
    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method protected static getMD5(Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .param p0, "val"    # Ljava/lang/String;

    .prologue
    .line 132
    const-string v4, ""

    .line 134
    .local v4, "ret":Ljava/lang/String;
    :try_start_0
    const-string v6, "MD5"

    invoke-static {v6}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v3

    .line 135
    .local v3, "md5":Ljava/security/MessageDigest;
    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object v6

    invoke-virtual {v3, v6}, Ljava/security/MessageDigest;->update([B)V

    .line 136
    invoke-virtual {v3}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v2

    .line 139
    .local v2, "m":[B
    new-instance v5, Ljava/lang/StringBuffer;

    invoke-direct {v5}, Ljava/lang/StringBuffer;-><init>()V

    .line 140
    .local v5, "sb":Ljava/lang/StringBuffer;
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    array-length v6, v2

    if-ge v1, v6, :cond_0

    .line 141
    aget-byte v6, v2, v1

    invoke-virtual {v5, v6}, Ljava/lang/StringBuffer;->append(I)Ljava/lang/StringBuffer;

    .line 140
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 143
    :cond_0
    invoke-virtual {v5}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v4

    .line 148
    .end local v1    # "i":I
    .end local v2    # "m":[B
    .end local v3    # "md5":Ljava/security/MessageDigest;
    .end local v5    # "sb":Ljava/lang/StringBuffer;
    :goto_1
    return-object v4

    .line 144
    :catch_0
    move-exception v0

    .line 146
    .local v0, "e":Ljava/security/NoSuchAlgorithmException;
    invoke-virtual {v0}, Ljava/security/NoSuchAlgorithmException;->printStackTrace()V

    goto :goto_1
.end method

.method public static getPrefs()Landroid/content/SharedPreferences;
    .locals 2

    .prologue
    .line 27
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mPrefs:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    .line 28
    const-string v0, "DYSDK"

    const-string v1, "Init DYSDK first!"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 30
    :cond_0
    sget-boolean v0, Lcom/dygame/dysdk/DYSdkHelper;->$assertionsDisabled:Z

    if-nez v0, :cond_1

    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mPrefs:Landroid/content/SharedPreferences;

    if-nez v0, :cond_1

    new-instance v0, Ljava/lang/AssertionError;

    invoke-direct {v0}, Ljava/lang/AssertionError;-><init>()V

    throw v0

    .line 31
    :cond_1
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mPrefs:Landroid/content/SharedPreferences;

    return-object v0
.end method

.method public static init(Landroid/content/Context;)V
    .locals 1
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 23
    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    sput-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mPrefs:Landroid/content/SharedPreferences;

    .line 24
    return-void
.end method

.method public static isGuest()Z
    .locals 4

    .prologue
    .line 53
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    sget-object v2, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 55
    .local v0, "isGuest":Z
    return v0
.end method

.method protected static isValidMobile(Ljava/lang/String;)Z
    .locals 4
    .param p0, "mb"    # Ljava/lang/String;

    .prologue
    .line 153
    const-string v2, "^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$"

    .line 154
    .local v2, "regExp":Ljava/lang/String;
    invoke-static {v2}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v1

    .line 155
    .local v1, "p":Ljava/util/regex/Pattern;
    invoke-virtual {v1, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 156
    .local v0, "m":Ljava/util/regex/Matcher;
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    return v3
.end method

.method protected static isValidPasswd(Ljava/lang/String;)Z
    .locals 4
    .param p0, "pass"    # Ljava/lang/String;

    .prologue
    .line 160
    const-string v2, "[0-9a-zA-Z]{6,20}"

    .line 161
    .local v2, "regExp":Ljava/lang/String;
    invoke-static {v2}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v1

    .line 162
    .local v1, "p":Ljava/util/regex/Pattern;
    invoke-virtual {v1, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 163
    .local v0, "m":Ljava/util/regex/Matcher;
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    return v3
.end method

.method protected static leftTickForGetVerify()J
    .locals 8

    .prologue
    .line 119
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 120
    .local v2, "tick":J
    sget-wide v4, Lcom/dygame/dysdk/DYSDK;->TICK_GET_VERIFY_MAX:J

    sget-wide v6, Lcom/dygame/dysdk/DYSDK;->TICK_GET_VERIFY:J

    sub-long v6, v2, v6

    sub-long v0, v4, v6

    .line 121
    .local v0, "left":J
    const-wide/16 v4, 0x0

    cmp-long v4, v0, v4

    if-gez v4, :cond_0

    .line 122
    const-wide/16 v0, 0x0

    .line 124
    :cond_0
    return-wide v0
.end method

.method public static login(Landroid/app/Activity;Lcom/dygame/dysdk/DYSdkLoginListener;)V
    .locals 4
    .param p0, "ctx"    # Landroid/app/Activity;
    .param p1, "listener"    # Lcom/dygame/dysdk/DYSdkLoginListener;

    .prologue
    .line 35
    sput-object p0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginContext:Landroid/app/Activity;

    .line 36
    sput-object p1, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    .line 38
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    sget-object v2, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 40
    .local v0, "tName":Ljava/lang/String;
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_0

    .line 41
    invoke-static {p0}, Lcom/dygame/dysdk/DYSdkHelper;->showAutoLoginDlg(Landroid/content/Context;)V

    .line 45
    :goto_0
    return-void

    .line 43
    :cond_0
    invoke-static {p0}, Lcom/dygame/dysdk/DYSdkHelper;->showLoginDlg(Landroid/content/Context;)V

    goto :goto_0
.end method

.method public static pay(Landroid/app/Activity;Ljava/lang/String;Lcom/dygame/dysdk/DYSdkPayListener;)V
    .locals 0
    .param p0, "ctx"    # Landroid/app/Activity;
    .param p1, "payParam"    # Ljava/lang/String;
    .param p2, "listener"    # Lcom/dygame/dysdk/DYSdkPayListener;

    .prologue
    .line 48
    sput-object p0, Lcom/dygame/dysdk/DYSdkHelper;->mPayContext:Landroid/app/Activity;

    .line 49
    sput-object p2, Lcom/dygame/dysdk/DYSdkHelper;->mPayListener:Lcom/dygame/dysdk/DYSdkPayListener;

    .line 50
    return-void
.end method

.method public static revokeLoginResult(ZLcom/dygame/dysdk/DYSdkLoginResult;)V
    .locals 2
    .param p0, "bSucc"    # Z
    .param p1, "result"    # Lcom/dygame/dysdk/DYSdkLoginResult;

    .prologue
    .line 63
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginContext:Landroid/app/Activity;

    if-nez v0, :cond_1

    .line 77
    :cond_0
    :goto_0
    return-void

    .line 66
    :cond_1
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginContext:Landroid/app/Activity;

    new-instance v1, Lcom/dygame/dysdk/DYSdkHelper$1;

    invoke-direct {v1, p0, p1}, Lcom/dygame/dysdk/DYSdkHelper$1;-><init>(ZLcom/dygame/dysdk/DYSdkLoginResult;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static revokeLogoutResult(Z)V
    .locals 2
    .param p0, "bSucc"    # Z

    .prologue
    .line 80
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginListener:Lcom/dygame/dysdk/DYSdkLoginListener;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginContext:Landroid/app/Activity;

    if-nez v0, :cond_1

    .line 89
    :cond_0
    :goto_0
    return-void

    .line 83
    :cond_1
    sget-object v0, Lcom/dygame/dysdk/DYSdkHelper;->mLoginContext:Landroid/app/Activity;

    new-instance v1, Lcom/dygame/dysdk/DYSdkHelper$2;

    invoke-direct {v1}, Lcom/dygame/dysdk/DYSdkHelper$2;-><init>()V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method protected static saveTickForGetVerify()V
    .locals 2

    .prologue
    .line 128
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sput-wide v0, Lcom/dygame/dysdk/DYSDK;->TICK_GET_VERIFY:J

    .line 129
    return-void
.end method

.method protected static showAutoLoginDlg(Landroid/content/Context;)V
    .locals 2
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 113
    new-instance v0, Lcom/dygame/dysdk/AutoLoginDlg;

    sget v1, Lcom/dygame/dysdk/R$style;->dysdk_dialog_style:I

    invoke-direct {v0, p0, v1}, Lcom/dygame/dysdk/AutoLoginDlg;-><init>(Landroid/content/Context;I)V

    .line 114
    .local v0, "dlg":Lcom/dygame/dysdk/AutoLoginDlg;
    invoke-virtual {v0}, Lcom/dygame/dysdk/AutoLoginDlg;->show()V

    .line 115
    return-void
.end method

.method protected static showBindDlg(Landroid/content/Context;)V
    .locals 2
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 103
    new-instance v0, Lcom/dygame/dysdk/UserBindDlg;

    sget v1, Lcom/dygame/dysdk/R$style;->dysdk_dialog_style:I

    invoke-direct {v0, p0, v1}, Lcom/dygame/dysdk/UserBindDlg;-><init>(Landroid/content/Context;I)V

    .line 104
    .local v0, "dlg":Lcom/dygame/dysdk/UserBindDlg;
    invoke-virtual {v0}, Lcom/dygame/dysdk/UserBindDlg;->show()V

    .line 105
    return-void
.end method

.method protected static showLoginDlg(Landroid/content/Context;)V
    .locals 2
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 93
    new-instance v0, Lcom/dygame/dysdk/LoginInputDlg;

    sget v1, Lcom/dygame/dysdk/R$style;->dysdk_dialog_style:I

    invoke-direct {v0, p0, v1}, Lcom/dygame/dysdk/LoginInputDlg;-><init>(Landroid/content/Context;I)V

    .line 94
    .local v0, "dlg":Lcom/dygame/dysdk/LoginInputDlg;
    invoke-virtual {v0}, Lcom/dygame/dysdk/LoginInputDlg;->show()V

    .line 95
    return-void
.end method

.method protected static showResetDlg(Landroid/content/Context;)V
    .locals 2
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 108
    new-instance v0, Lcom/dygame/dysdk/ForgetPassDlg;

    sget v1, Lcom/dygame/dysdk/R$style;->dysdk_dialog_style:I

    invoke-direct {v0, p0, v1}, Lcom/dygame/dysdk/ForgetPassDlg;-><init>(Landroid/content/Context;I)V

    .line 109
    .local v0, "dlg":Lcom/dygame/dysdk/ForgetPassDlg;
    invoke-virtual {v0}, Lcom/dygame/dysdk/ForgetPassDlg;->show()V

    .line 110
    return-void
.end method

.method protected static showRigisterDlg(Landroid/content/Context;)V
    .locals 2
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 98
    new-instance v0, Lcom/dygame/dysdk/UserRegDlg;

    sget v1, Lcom/dygame/dysdk/R$style;->dysdk_dialog_style:I

    invoke-direct {v0, p0, v1}, Lcom/dygame/dysdk/UserRegDlg;-><init>(Landroid/content/Context;I)V

    .line 99
    .local v0, "dlg":Lcom/dygame/dysdk/UserRegDlg;
    invoke-virtual {v0}, Lcom/dygame/dysdk/UserRegDlg;->show()V

    .line 100
    return-void
.end method
