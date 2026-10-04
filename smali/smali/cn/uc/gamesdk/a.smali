.class public Lcn/uc/gamesdk/a;
.super Ljava/lang/Object;

# interfaces
.implements Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcn/uc/gamesdk/iface/Listener/SdkCallbackListener",
        "<",
        "Landroid/os/Bundle;",
        "Landroid/os/Bundle;",
        ">;"
    }
.end annotation


# static fields
.field private static a:Lcn/uc/gamesdk/a;


# instance fields
.field private b:Landroid/content/Context;

.field private c:Lcn/uc/gamesdk/IGameUserLogin;

.field private d:Lcn/uc/gamesdk/UCCallbackListener;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x0

    sput-object v0, Lcn/uc/gamesdk/a;->a:Lcn/uc/gamesdk/a;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcn/uc/gamesdk/a;->b:Landroid/content/Context;

    return-void
.end method

.method public static a()Lcn/uc/gamesdk/a;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/a;->a:Lcn/uc/gamesdk/a;

    if-nez v0, :cond_0

    new-instance v0, Lcn/uc/gamesdk/a;

    invoke-direct {v0}, Lcn/uc/gamesdk/a;-><init>()V

    sput-object v0, Lcn/uc/gamesdk/a;->a:Lcn/uc/gamesdk/a;

    :cond_0
    sget-object v0, Lcn/uc/gamesdk/a;->a:Lcn/uc/gamesdk/a;

    return-object v0
.end method


# virtual methods
.method public a(ILandroid/os/Bundle;)Landroid/os/Bundle;
    .locals 4

    new-instance v1, Landroid/os/Bundle;

    invoke-direct {v1}, Landroid/os/Bundle;-><init>()V

    packed-switch p1, :pswitch_data_0

    :cond_0
    :goto_0
    :pswitch_0
    return-object v1

    :pswitch_1
    const-string v0, "intent"

    invoke-virtual {p2, v0}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v0

    check-cast v0, Landroid/content/Intent;

    const/high16 v2, 0x10000000

    invoke-virtual {v0, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    if-eqz v0, :cond_0

    iget-object v2, p0, Lcn/uc/gamesdk/a;->b:Landroid/content/Context;

    const-class v3, Lcn/uc/gamesdk/SdkActivity;

    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->setClass(Landroid/content/Context;Ljava/lang/Class;)Landroid/content/Intent;

    iget-object v2, p0, Lcn/uc/gamesdk/a;->b:Landroid/content/Context;

    invoke-virtual {v2, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    goto :goto_0

    :pswitch_2
    iget-object v0, p0, Lcn/uc/gamesdk/a;->c:Lcn/uc/gamesdk/IGameUserLogin;

    if-eqz v0, :cond_1

    const-string v0, "gameAccount"

    invoke-virtual {p2, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "password"

    invoke-virtual {p2, v2}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lcn/uc/gamesdk/a;->c:Lcn/uc/gamesdk/IGameUserLogin;

    invoke-interface {v3, v0, v2}, Lcn/uc/gamesdk/IGameUserLogin;->process(Ljava/lang/String;Ljava/lang/String;)Lcn/uc/gamesdk/GameUserLoginResult;

    move-result-object v0

    invoke-virtual {v0}, Lcn/uc/gamesdk/GameUserLoginResult;->getLoginResult()I

    move-result v2

    invoke-virtual {v0}, Lcn/uc/gamesdk/GameUserLoginResult;->getSid()Ljava/lang/String;

    move-result-object v0

    const-string v3, "loginResult"

    invoke-virtual {v1, v3, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v2, "sid"

    invoke-virtual {v1, v2, v0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const-string v0, "loginResult"

    const/16 v2, -0xcb

    invoke-virtual {v1, v0, v2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string v0, "sid"

    const-string v2, ""

    invoke-virtual {v1, v0, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :pswitch_3
    const-string v0, "status"

    invoke-virtual {p2, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    const-string v2, "msg"

    invoke-virtual {p2, v2}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0}, Lcn/uc/gamesdk/a;->b()Lcn/uc/gamesdk/UCCallbackListener;

    move-result-object v3

    invoke-interface {v3, v0, v2}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    goto :goto_0

    :pswitch_4
    const-string v0, "ucid"

    invoke-virtual {p2, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    sput v0, Lcn/uc/gamesdk/a/d;->f:I

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_1
        :pswitch_2
        :pswitch_0
        :pswitch_3
        :pswitch_4
    .end packed-switch
.end method

.method public a(Landroid/content/Context;)Lcn/uc/gamesdk/a;
    .locals 1

    iput-object p1, p0, Lcn/uc/gamesdk/a;->b:Landroid/content/Context;

    sget-object v0, Lcn/uc/gamesdk/a;->a:Lcn/uc/gamesdk/a;

    return-object v0
.end method

.method public a(Lcn/uc/gamesdk/IGameUserLogin;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/a;->c:Lcn/uc/gamesdk/IGameUserLogin;

    return-void
.end method

.method public a(Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    iput-object p1, p0, Lcn/uc/gamesdk/a;->d:Lcn/uc/gamesdk/UCCallbackListener;

    return-void
.end method

.method public b()Lcn/uc/gamesdk/UCCallbackListener;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Lcn/uc/gamesdk/UCCallbackListener",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcn/uc/gamesdk/a;->d:Lcn/uc/gamesdk/UCCallbackListener;

    return-object v0
.end method

.method public synthetic callback(ILjava/lang/Object;)Ljava/lang/Object;
    .locals 1

    check-cast p2, Landroid/os/Bundle;

    invoke-virtual {p0, p1, p2}, Lcn/uc/gamesdk/a;->a(ILandroid/os/Bundle;)Landroid/os/Bundle;

    move-result-object v0

    return-object v0
.end method
