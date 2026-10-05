.class public Lcom/dygame/open/dataeye/DCLuaLevels;
.super Ljava/lang/Object;
.source "DCLuaLevels.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static begin(Ljava/lang/String;)V
    .locals 0
    .param p0, "levelId"    # Ljava/lang/String;

    .prologue
    .line 9
    invoke-static {p0}, Lcom/dataeye/plugin/DCLevels;->begin(Ljava/lang/String;)V

    .line 10
    return-void
.end method

.method public static complete(Ljava/lang/String;)V
    .locals 0
    .param p0, "levelId"    # Ljava/lang/String;

    .prologue
    .line 13
    invoke-static {p0}, Lcom/dataeye/plugin/DCLevels;->complete(Ljava/lang/String;)V

    .line 14
    return-void
.end method

.method public static fail(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .param p0, "levelId"    # Ljava/lang/String;
    .param p1, "failPoint"    # Ljava/lang/String;

    .prologue
    .line 17
    invoke-static {p0, p1}, Lcom/dataeye/plugin/DCLevels;->fail(Ljava/lang/String;Ljava/lang/String;)V

    .line 18
    return-void
.end method
