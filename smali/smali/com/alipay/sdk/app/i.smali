.class final Lcom/alipay/sdk/app/i;
.super Ljava/lang/Thread;


# instance fields
.field final synthetic a:Lcom/alipay/sdk/app/h;


# direct methods
.method constructor <init>(Lcom/alipay/sdk/app/h;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/sdk/app/i;->a:Lcom/alipay/sdk/app/h;

    invoke-direct {p0}, Ljava/lang/Thread;-><init>()V

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/alipay/sdk/app/i;->a:Lcom/alipay/sdk/app/h;

    iget-object v0, v0, Lcom/alipay/sdk/app/h;->a:Lcom/alipay/sdk/app/H5AuthActivity;

    invoke-static {v0}, Lcom/alipay/sdk/app/H5AuthActivity;->a(Lcom/alipay/sdk/app/H5AuthActivity;)V

    return-void
.end method
