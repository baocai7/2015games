.class public Lcom/dygame/open/dataeye/DYDataEyeHelper;
.super Ljava/lang/Object;
.source "DYDataEyeHelper.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static onCreate()V
    .locals 1

    .prologue
    .line 10
    const/16 v0, 0x5a

    invoke-static {v0}, Lcom/dataeye/DCAgent;->setUploadInterval(I)V

    .line 11
    const/4 v0, 0x2

    invoke-static {v0}, Lcom/dataeye/DCAgent;->setReportMode(I)V

    .line 12
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/dataeye/DCAgent;->setDebugMode(Z)V

    .line 13
    return-void
.end method

.method public static onDestroy()V
    .locals 0

    .prologue
    .line 25
    invoke-static {}, Lcom/dataeye/DCAgent;->onKillProcessOrExit()V

    .line 26
    return-void
.end method

.method public static onPause()V
    .locals 1

    .prologue
    .line 16
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v0}, Lcom/dataeye/DCAgent;->onPause(Landroid/content/Context;)V

    .line 17
    return-void
.end method

.method public static onResume()V
    .locals 1

    .prologue
    .line 21
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    invoke-static {v0}, Lcom/dataeye/DCAgent;->onResume(Landroid/content/Context;)V

    .line 22
    return-void
.end method
