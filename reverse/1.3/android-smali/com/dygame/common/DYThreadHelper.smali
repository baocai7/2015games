.class public Lcom/dygame/common/DYThreadHelper;
.super Ljava/lang/Object;
.source "DYThreadHelper.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static runOnGLThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "tInstance"    # Ljava/lang/Object;
    .param p1, "strMethod"    # Ljava/lang/String;
    .param p2, "strParam"    # Ljava/lang/String;

    .prologue
    .line 64
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    if-nez v0, :cond_0

    .line 87
    :goto_0
    return-void

    .line 69
    :cond_0
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    new-instance v1, Lcom/dygame/common/DYThreadHelper$3;

    invoke-direct {v1, p0, p1, p2}, Lcom/dygame/common/DYThreadHelper$3;-><init>(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Lcom/dygame/common/DYGame;->runOnGLThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static runOnUIThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "tInstance"    # Ljava/lang/Object;
    .param p1, "strMethod"    # Ljava/lang/String;
    .param p2, "strParam"    # Ljava/lang/String;

    .prologue
    .line 9
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    if-nez v0, :cond_0

    .line 32
    :goto_0
    return-void

    .line 14
    :cond_0
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    new-instance v1, Lcom/dygame/common/DYThreadHelper$1;

    invoke-direct {v1, p0, p1, p2}, Lcom/dygame/common/DYThreadHelper$1;-><init>(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Lcom/dygame/common/DYGame;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static runStaticFunctionOnGLThread(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p1, "strMethod"    # Ljava/lang/String;
    .param p2, "strParam"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class",
            "<*>;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .prologue
    .line 91
    .local p0, "clazz":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    if-nez v0, :cond_0

    .line 114
    :goto_0
    return-void

    .line 96
    :cond_0
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    new-instance v1, Lcom/dygame/common/DYThreadHelper$4;

    invoke-direct {v1, p0, p1, p2}, Lcom/dygame/common/DYThreadHelper$4;-><init>(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Lcom/dygame/common/DYGame;->runOnGLThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method public static runStaticFunctionOnUIThread(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p1, "strMethod"    # Ljava/lang/String;
    .param p2, "strParam"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class",
            "<*>;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .prologue
    .line 36
    .local p0, "clazz":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    if-nez v0, :cond_0

    .line 59
    :goto_0
    return-void

    .line 41
    :cond_0
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    new-instance v1, Lcom/dygame/common/DYThreadHelper$2;

    invoke-direct {v1, p0, p1, p2}, Lcom/dygame/common/DYThreadHelper$2;-><init>(Ljava/lang/Class;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Lcom/dygame/common/DYGame;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method
