.class final Lcn/uc/a/a/a/k$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/a/a/a/k;->b(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic a:Ljava/lang/String;

.field final synthetic b:Lcn/uc/a/a/a/i$a;


# direct methods
.method constructor <init>(Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/a/a/a/k$1;->a:Ljava/lang/String;

    iput-object p2, p0, Lcn/uc/a/a/a/k$1;->b:Lcn/uc/a/a/a/i$a;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    const-string v0, "ci:%s|csid:%s|sequence:%d|isfirst:%s"

    const/4 v1, 0x4

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-static {}, Lcn/uc/a/a/a/k;->b()Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x1

    invoke-static {}, Lcn/uc/a/a/a/k;->c()Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x2

    invoke-static {}, Lcn/uc/a/a/a/k;->d()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x3

    invoke-static {}, Lcn/uc/a/a/a/k;->e()Z

    move-result v3

    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    aput-object v3, v1, v2

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/a/a/a/k$1;->a:Ljava/lang/String;

    iget-object v2, p0, Lcn/uc/a/a/a/k$1;->b:Lcn/uc/a/a/a/i$a;

    invoke-static {v1, v0, v2}, Lcn/uc/a/a/a/k;->a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V

    const-string v0, "true"

    invoke-static {}, Lcn/uc/a/a/a/k;->f()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcn/uc/a/a/a/k$1;->a:Ljava/lang/String;

    sget-object v1, Lcn/uc/a/a/a/e;->g:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    :cond_0
    return-void
.end method
