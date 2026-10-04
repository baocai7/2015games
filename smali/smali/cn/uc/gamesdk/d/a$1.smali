.class final Lcn/uc/gamesdk/d/a$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Thread$UncaughtExceptionHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/gamesdk/d/a;->a(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic a:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/d/a$1;->a:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public uncaughtException(Ljava/lang/Thread;Ljava/lang/Throwable;)V
    .locals 9

    const/4 v8, 0x0

    const/4 v7, 0x1

    :try_start_0
    new-instance v0, Ljava/io/StringWriter;

    invoke-direct {v0}, Ljava/io/StringWriter;-><init>()V

    new-instance v1, Ljava/io/PrintWriter;

    invoke-direct {v1, v0}, Ljava/io/PrintWriter;-><init>(Ljava/io/Writer;)V

    invoke-virtual {p2, v1}, Ljava/lang/Throwable;->printStackTrace(Ljava/io/PrintWriter;)V

    invoke-virtual {v1}, Ljava/io/PrintWriter;->close()V

    invoke-virtual {v0}, Ljava/io/StringWriter;->close()V

    const-string v0, "CommonUtil"

    const-string v1, "uncaughtException"

    const-string v2, "unknown"

    const/4 v3, 0x0

    new-instance v4, Ljava/lang/Exception;

    invoke-direct {v4, p2}, Ljava/lang/Exception;-><init>(Ljava/lang/Throwable;)V

    const/4 v5, 0x1

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    const-string v0, "\u5f88\u62b1\u6b49\uff0c\u7a0b\u5e8f\u51fa\u73b0\u5f02\u5e38\uff0c\u5373\u5c06\u9000\u51fa\u3002"

    invoke-static {v0}, Lcn/uc/gamesdk/a/e;->a(Ljava/lang/String;)V

    const-wide/16 v0, 0xbb8

    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V

    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.MAIN"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "android.intent.category.HOME"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v1, 0x14000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setFlags(I)Landroid/content/Intent;

    iget-object v1, p0, Lcn/uc/gamesdk/d/a$1;->a:Landroid/content/Context;

    invoke-virtual {v1, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    invoke-static {v0}, Landroid/os/Process;->killProcess(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :goto_0
    return-void

    :catch_0
    move-exception v4

    const-string v0, "CommonUtil"

    const-string v1, "uncaughtException"

    const-string v2, "unknown"

    sget-object v6, Lcn/uc/gamesdk/a/a;->a:Ljava/lang/String;

    move-object v3, v8

    move v5, v7

    invoke-static/range {v0 .. v6}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto :goto_0
.end method
