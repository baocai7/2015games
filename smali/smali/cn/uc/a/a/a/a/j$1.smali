.class Lcn/uc/a/a/a/a/j$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/a/a/a/a/j;-><init>(Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Lcn/uc/a/a/a/a/m;

.field final synthetic b:Lcn/uc/a/a/a/a/j;


# direct methods
.method constructor <init>(Lcn/uc/a/a/a/a/j;Lcn/uc/a/a/a/a/m;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/a/a/a/a/j$1;->b:Lcn/uc/a/a/a/a/j;

    iput-object p2, p0, Lcn/uc/a/a/a/a/j$1;->a:Lcn/uc/a/a/a/a/m;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    iget-object v0, p0, Lcn/uc/a/a/a/a/j$1;->a:Lcn/uc/a/a/a/a/m;

    iget-object v1, p0, Lcn/uc/a/a/a/a/j$1;->b:Lcn/uc/a/a/a/a/j;

    invoke-static {v1}, Lcn/uc/a/a/a/a/j;->a(Lcn/uc/a/a/a/a/j;)I

    move-result v1

    invoke-interface {v0, v1}, Lcn/uc/a/a/a/a/m;->a(I)V

    return-void
.end method
