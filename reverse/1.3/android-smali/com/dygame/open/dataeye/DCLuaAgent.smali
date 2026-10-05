.class public Lcom/dygame/open/dataeye/DCLuaAgent;
.super Ljava/lang/Object;
.source "DCLuaAgent.java"


# static fields
.field private static TAG:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 9
    const-string v0, "DataEye:DCLuaAgent"

    sput-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getUID()Ljava/lang/String;
    .locals 2

    .prologue
    .line 48
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "getUID"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 49
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v0}, Lcom/dataeye/DCAgent;->getUID(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static onStart(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "appId"    # Ljava/lang/String;
    .param p1, "channelId"    # Ljava/lang/String;

    .prologue
    .line 13
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "onStart"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 14
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v0, p0, p1}, Lcom/dataeye/DCAgent;->initConfig(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 15
    return-void
.end method

.method public static reportError(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "title"    # Ljava/lang/String;
    .param p1, "error"    # Ljava/lang/String;

    .prologue
    .line 38
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "reportError"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 39
    invoke-static {p0, p1}, Lcom/dataeye/DCAgent;->reportError(Ljava/lang/String;Ljava/lang/String;)V

    .line 40
    return-void
.end method

.method public static setDebugMode(Ljava/lang/String;)V
    .locals 2
    .param p0, "mode"    # Ljava/lang/String;

    .prologue
    .line 18
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "setDebugMode"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 19
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAgent;->setDebugMode(Z)V

    .line 20
    return-void
.end method

.method public static setReportMode(Ljava/lang/String;)V
    .locals 2
    .param p0, "mode"    # Ljava/lang/String;

    .prologue
    .line 23
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "setReportMode"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 24
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAgent;->setReportMode(I)V

    .line 25
    return-void
.end method

.method public static setUploadInterval(Ljava/lang/String;)V
    .locals 2
    .param p0, "second"    # Ljava/lang/String;

    .prologue
    .line 28
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "setUploadInterval"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 29
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {v0}, Lcom/dataeye/DCAgent;->setUploadInterval(I)V

    .line 30
    return-void
.end method

.method public static setVersion(Ljava/lang/String;)V
    .locals 2
    .param p0, "appVersion"    # Ljava/lang/String;

    .prologue
    .line 33
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "setVersion"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 34
    invoke-static {p0}, Lcom/dataeye/DCAgent;->setVersion(Ljava/lang/String;)V

    .line 35
    return-void
.end method

.method public static uploadNow()V
    .locals 2

    .prologue
    .line 43
    sget-object v0, Lcom/dygame/open/dataeye/DCLuaAgent;->TAG:Ljava/lang/String;

    const-string v1, "uploadNow"

    invoke-static {v0, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 44
    invoke-static {}, Lcom/dataeye/DCAgent;->uploadNow()V

    .line 45
    return-void
.end method
