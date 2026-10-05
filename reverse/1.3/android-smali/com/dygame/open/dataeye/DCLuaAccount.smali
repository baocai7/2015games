.class public Lcom/dygame/open/dataeye/DCLuaAccount;
.super Ljava/lang/Object;
.source "DCLuaAccount.java"


# static fields
.field private static TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 8
    const-string v0, "DataEye:DCLuaAccount"

    sput-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static addTag(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "tag"    # Ljava/lang/String;
    .param p1, "subTag"    # Ljava/lang/String;

    .prologue
    .line 51
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "addTag"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 52
    invoke-static {p0, p1}, Lcom/dataeye/DCAccount;->addTag(Ljava/lang/String;Ljava/lang/String;)V

    .line 53
    return-void
.end method

.method public static getAccountId()Ljava/lang/String;
    .locals 2

    .prologue
    .line 21
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "getAccountId"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 22
    invoke-static {}, Lcom/dataeye/DCAccount;->getAccountId()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static login(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "accountId"    # Ljava/lang/String;
    .param p1, "gameServer"    # Ljava/lang/String;

    .prologue
    .line 11
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "login"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 12
    invoke-static {p0, p1}, Lcom/dataeye/DCAccount;->login(Ljava/lang/String;Ljava/lang/String;)V

    .line 13
    return-void
.end method

.method public static logout()V
    .locals 2

    .prologue
    .line 16
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "logout"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 17
    invoke-static {}, Lcom/dataeye/DCAccount;->logout()V

    .line 18
    return-void
.end method

.method public static removeTag(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "tag"    # Ljava/lang/String;
    .param p1, "subTag"    # Ljava/lang/String;

    .prologue
    .line 56
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "removeTag"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 57
    invoke-static {p0, p1}, Lcom/dataeye/DCAccount;->removeTag(Ljava/lang/String;Ljava/lang/String;)V

    .line 58
    return-void
.end method

.method public static setAccountType(Ljava/lang/String;)V
    .locals 2
    .param p0, "accountType"    # Ljava/lang/String;

    .prologue
    .line 26
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "setAccountType"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 27
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAccount;->setAccountType(I)V

    .line 28
    return-void
.end method

.method public static setAge(Ljava/lang/String;)V
    .locals 2
    .param p0, "age"    # Ljava/lang/String;

    .prologue
    .line 41
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "setAge"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 42
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAccount;->setAge(I)V

    .line 43
    return-void
.end method

.method public static setGameServer(Ljava/lang/String;)V
    .locals 2
    .param p0, "server"    # Ljava/lang/String;

    .prologue
    .line 45
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "setGameServer"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 46
    invoke-static {p0}, Lcom/dataeye/DCAccount;->setGameServer(Ljava/lang/String;)V

    .line 48
    return-void
.end method

.method public static setGender(Ljava/lang/String;)V
    .locals 2
    .param p0, "gender"    # Ljava/lang/String;

    .prologue
    .line 36
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "setGender"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 37
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAccount;->setGender(I)V

    .line 38
    return-void
.end method

.method public static setLevel(Ljava/lang/String;)V
    .locals 2
    .param p0, "level"    # Ljava/lang/String;

    .prologue
    .line 31
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAccount;->TAG:Ljava/lang/String;

    const-string v1, "setLevel"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 32
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAccount;->setLevel(I)V

    .line 33
    return-void
.end method
