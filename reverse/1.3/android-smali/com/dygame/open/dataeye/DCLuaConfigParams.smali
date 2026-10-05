.class public Lcom/dygame/open/dataeye/DCLuaConfigParams;
.super Ljava/lang/Object;
.source "DCLuaConfigParams.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getParam(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "defaultValue"    # Ljava/lang/String;

    .prologue
    .line 11
    invoke-static {p0, p1}, Lcom/dataeye/DCConfigParams;->getParameterString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static update()V
    .locals 0

    .prologue
    .line 7
    invoke-static {}, Lcom/dataeye/DCConfigParams;->update()V

    .line 8
    return-void
.end method
