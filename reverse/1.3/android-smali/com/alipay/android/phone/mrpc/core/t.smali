.class final Lcom/alipay/android/phone/mrpc/core/t;
.super Ljava/util/concurrent/FutureTask;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/util/concurrent/FutureTask",
        "<",
        "Lcom/alipay/android/phone/mrpc/core/ab;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic a:Lcom/alipay/android/phone/mrpc/core/x;

.field final synthetic b:Lcom/alipay/android/phone/mrpc/core/s;


# direct methods
.method constructor <init>(Lcom/alipay/android/phone/mrpc/core/s;Ljava/util/concurrent/Callable;Lcom/alipay/android/phone/mrpc/core/x;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/android/phone/mrpc/core/t;->b:Lcom/alipay/android/phone/mrpc/core/s;

    iput-object p3, p0, Lcom/alipay/android/phone/mrpc/core/t;->a:Lcom/alipay/android/phone/mrpc/core/x;

    invoke-direct {p0, p2}, Ljava/util/concurrent/FutureTask;-><init>(Ljava/util/concurrent/Callable;)V

    return-void
.end method


# virtual methods
.method protected final done()V
    .locals 3

    const/4 v2, 0x1

    iget-object v0, p0, Lcom/alipay/android/phone/mrpc/core/t;->a:Lcom/alipay/android/phone/mrpc/core/x;

    invoke-virtual {v0}, Lcom/alipay/android/phone/mrpc/core/x;->a()Lcom/alipay/android/phone/mrpc/core/v;

    move-result-object v0

    invoke-virtual {v0}, Lcom/alipay/android/phone/mrpc/core/aa;->a()Lcom/alipay/android/phone/mrpc/core/g;

    move-result-object v1

    if-nez v1, :cond_1

    invoke-super {p0}, Ljava/util/concurrent/FutureTask;->done()V

    :cond_0
    :goto_0
    return-void

    :cond_1
    :try_start_0
    invoke-virtual {p0}, Lcom/alipay/android/phone/mrpc/core/t;->get()Ljava/lang/Object;

    invoke-virtual {p0}, Lcom/alipay/android/phone/mrpc/core/t;->isCancelled()Z

    move-result v1

    if-nez v1, :cond_2

    iget-boolean v1, v0, Lcom/alipay/android/phone/mrpc/core/aa;->f:Z

    if-eqz v1, :cond_0

    :cond_2
    const/4 v1, 0x1

    iput-boolean v1, v0, Lcom/alipay/android/phone/mrpc/core/aa;->f:Z

    invoke-virtual {p0}, Lcom/alipay/android/phone/mrpc/core/t;->isCancelled()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-virtual {p0}, Lcom/alipay/android/phone/mrpc/core/t;->isDone()Z

    move-result v1

    if-nez v1, :cond_0

    :cond_3
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Lcom/alipay/android/phone/mrpc/core/t;->cancel(Z)Z
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/util/concurrent/ExecutionException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/util/concurrent/CancellationException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_3

    goto :goto_0

    :catch_0
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    goto :goto_0

    :catch_1
    move-exception v0

    invoke-virtual {v0}, Ljava/util/concurrent/ExecutionException;->getCause()Ljava/lang/Throwable;

    move-result-object v1

    if-eqz v1, :cond_4

    invoke-virtual {v0}, Ljava/util/concurrent/ExecutionException;->getCause()Ljava/lang/Throwable;

    move-result-object v1

    instance-of v1, v1, Lcom/alipay/android/phone/mrpc/core/a;

    if-eqz v1, :cond_4

    invoke-virtual {v0}, Ljava/util/concurrent/ExecutionException;->getCause()Ljava/lang/Throwable;

    move-result-object v0

    check-cast v0, Lcom/alipay/android/phone/mrpc/core/a;

    iget v1, v0, Lcom/alipay/android/phone/mrpc/core/a;->k:I

    iget-object v0, v0, Lcom/alipay/android/phone/mrpc/core/a;->l:Ljava/lang/String;

    goto :goto_0

    :cond_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    goto :goto_0

    :catch_2
    move-exception v1

    iput-boolean v2, v0, Lcom/alipay/android/phone/mrpc/core/aa;->f:Z

    goto :goto_0

    :catch_3
    move-exception v0

    new-instance v1, Ljava/lang/RuntimeException;

    const-string v2, "An error occured while executing http request"

    invoke-direct {v1, v2, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method
