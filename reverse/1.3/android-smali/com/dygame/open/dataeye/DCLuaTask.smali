.class public Lcom/dygame/open/dataeye/DCLuaTask;
.super Ljava/lang/Object;
.source "DCLuaTask.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static begin(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "taskId"    # Ljava/lang/String;
    .param p1, "taskType"    # Ljava/lang/String;

    .prologue
    .line 7
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {p0, v0}, Lcom/dataeye/DCTask;->begin(Ljava/lang/String;I)V

    .line 8
    return-void
.end method

.method public static complete(Ljava/lang/String;)V
    .locals 0
    .param p0, "taskId"    # Ljava/lang/String;

    .prologue
    .line 11
    invoke-static {p0}, Lcom/dataeye/DCTask;->complete(Ljava/lang/String;)V

    .line 12
    return-void
.end method

.method public static fail(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .param p0, "taskId"    # Ljava/lang/String;
    .param p1, "reason"    # Ljava/lang/String;

    .prologue
    .line 15
    invoke-static {p0, p1}, Lcom/dataeye/DCTask;->fail(Ljava/lang/String;Ljava/lang/String;)V

    .line 16
    return-void
.end method
