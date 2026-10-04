.class final Lcn/uc/a/a/a/a/g$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Lcn/uc/a/a/a/a/c;Lcn/uc/a/a/a/a/h;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic a:Ljava/lang/String;

.field final synthetic b:Lcn/uc/a/a/a/a/c;

.field final synthetic c:Ljava/lang/String;

.field final synthetic d:Lcn/uc/a/a/a/a/h;


# direct methods
.method constructor <init>(Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;Lcn/uc/a/a/a/a/h;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/a/a/a/a/g$1;->a:Ljava/lang/String;

    iput-object p2, p0, Lcn/uc/a/a/a/a/g$1;->b:Lcn/uc/a/a/a/a/c;

    iput-object p3, p0, Lcn/uc/a/a/a/a/g$1;->c:Ljava/lang/String;

    iput-object p4, p0, Lcn/uc/a/a/a/a/g$1;->d:Lcn/uc/a/a/a/a/h;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    const/4 v0, 0x0

    iget-object v1, p0, Lcn/uc/a/a/a/a/g$1;->a:Ljava/lang/String;

    iget-object v2, p0, Lcn/uc/a/a/a/a/g$1;->b:Lcn/uc/a/a/a/a/c;

    iget-object v3, p0, Lcn/uc/a/a/a/a/g$1;->c:Ljava/lang/String;

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/a/a/a/a/g$1;->d:Lcn/uc/a/a/a/a/h;

    invoke-interface {v1, v0}, Lcn/uc/a/a/a/a/h;->a(Lcn/uc/a/a/a/a/j;)V

    return-void
.end method
