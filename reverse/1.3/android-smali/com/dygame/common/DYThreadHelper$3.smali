.class final Lcom/dygame/common/DYThreadHelper$3;
.super Ljava/lang/Object;
.source "DYThreadHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/common/DYThreadHelper;->runOnGLThread(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$strMethod:Ljava/lang/String;

.field final synthetic val$strParam:Ljava/lang/String;

.field final synthetic val$tInstance:Ljava/lang/Object;


# direct methods
.method constructor <init>(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 70
    iput-object p1, p0, Lcom/dygame/common/DYThreadHelper$3;->val$tInstance:Ljava/lang/Object;

    iput-object p2, p0, Lcom/dygame/common/DYThreadHelper$3;->val$strMethod:Ljava/lang/String;

    iput-object p3, p0, Lcom/dygame/common/DYThreadHelper$3;->val$strParam:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 7

    .prologue
    .line 77
    :try_start_0
    iget-object v2, p0, Lcom/dygame/common/DYThreadHelper$3;->val$tInstance:Ljava/lang/Object;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    iget-object v3, p0, Lcom/dygame/common/DYThreadHelper$3;->val$strMethod:Ljava/lang/String;

    const/4 v4, 0x1

    new-array v4, v4, [Ljava/lang/Class;

    const/4 v5, 0x0

    const-class v6, Ljava/lang/String;

    aput-object v6, v4, v5

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 78
    .local v1, "method":Ljava/lang/reflect/Method;
    iget-object v2, p0, Lcom/dygame/common/DYThreadHelper$3;->val$tInstance:Ljava/lang/Object;

    const/4 v3, 0x1

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    iget-object v5, p0, Lcom/dygame/common/DYThreadHelper$3;->val$strParam:Ljava/lang/String;

    aput-object v5, v3, v4

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 85
    .end local v1    # "method":Ljava/lang/reflect/Method;
    :goto_0
    return-void

    .line 80
    :catch_0
    move-exception v0

    .line 83
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method
