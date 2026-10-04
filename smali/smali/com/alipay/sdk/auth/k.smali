.class final Lcom/alipay/sdk/auth/k;
.super Ljava/lang/Object;

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field final synthetic a:Lcom/alipay/sdk/auth/AuthActivity;


# direct methods
.method constructor <init>(Lcom/alipay/sdk/auth/AuthActivity;)V
    .locals 0

    iput-object p1, p0, Lcom/alipay/sdk/auth/k;->a:Lcom/alipay/sdk/auth/AuthActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    iget-object v0, p0, Lcom/alipay/sdk/auth/k;->a:Lcom/alipay/sdk/auth/AuthActivity;

    invoke-virtual {v0}, Lcom/alipay/sdk/auth/AuthActivity;->finish()V

    return-void
.end method
