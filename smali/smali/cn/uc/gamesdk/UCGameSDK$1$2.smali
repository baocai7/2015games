.class Lcn/uc/gamesdk/UCGameSDK$1$2;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/gamesdk/UCGameSDK$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Lcn/uc/gamesdk/UCGameSDK$1;


# direct methods
.method constructor <init>(Lcn/uc/gamesdk/UCGameSDK$1;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK$1$2;->a:Lcn/uc/gamesdk/UCGameSDK$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    const-string v0, "init"

    const-string v1, "A"

    const-string v2, "DexLoader created fail"

    const/4 v3, 0x1

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$1$2;->a:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v0, v0, Lcn/uc/gamesdk/UCGameSDK$1;->e:Lcn/uc/gamesdk/UCCallbackListener;

    const/16 v1, -0x64

    const-string v2, "\u52a0\u8f7d\u521d\u59cb\u5316\u5931\u8d25"

    invoke-interface {v0, v1, v2}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$1$2;->a:Lcn/uc/gamesdk/UCGameSDK$1;

    iget-object v0, v0, Lcn/uc/gamesdk/UCGameSDK$1;->f:Landroid/app/ProgressDialog;

    invoke-virtual {v0}, Landroid/app/ProgressDialog;->dismiss()V

    return-void
.end method
