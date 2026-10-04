.class final Lcn/uc/a/a/a/i$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJ)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic a:Ljava/lang/String;

.field final synthetic b:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/a/a/a/i$1;->a:Ljava/lang/String;

    iput-object p2, p0, Lcn/uc/a/a/a/i$1;->b:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    const/4 v1, 0x2

    iget-object v0, p0, Lcn/uc/a/a/a/i$1;->a:Ljava/lang/String;

    invoke-static {v0, v1, v1}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;II)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    invoke-virtual {v0}, Lcn/uc/a/a/a/a/j;->k()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "UCLog"

    const-string v1, "stat"

    const-string v2, "statlog \u4e0a\u4f20\u6210\u529f"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_0
    const-string v0, "UCLog"

    const-string v1, "stat"

    const-string v2, "\u65e5\u5fd7\u5373\u65f6\u4e0a\u4f20\u5931\u8d25\uff0c\u5199\u5165\u65e5\u5fd7\u6587\u4ef6"

    invoke-static {v0, v1, v2}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcn/uc/a/a/a/i$1;->b:Ljava/lang/String;

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    goto :goto_0
.end method
