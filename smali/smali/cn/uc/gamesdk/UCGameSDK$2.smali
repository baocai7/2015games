.class Lcn/uc/gamesdk/UCGameSDK$2;
.super Ljava/lang/Object;

# interfaces
.implements Lcn/uc/gamesdk/UCCallbackListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcn/uc/gamesdk/UCGameSDK;->pay(Landroid/content/Context;Lcn/uc/gamesdk/info/PaymentInfo;Lcn/uc/gamesdk/UCCallbackListener;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Lcn/uc/gamesdk/UCCallbackListener",
        "<",
        "Lorg/json/JSONObject;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic a:Lcn/uc/gamesdk/UCCallbackListener;

.field final synthetic b:Lcn/uc/gamesdk/UCGameSDK;


# direct methods
.method constructor <init>(Lcn/uc/gamesdk/UCGameSDK;Lcn/uc/gamesdk/UCCallbackListener;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/UCGameSDK$2;->b:Lcn/uc/gamesdk/UCGameSDK;

    iput-object p2, p0, Lcn/uc/gamesdk/UCGameSDK$2;->a:Lcn/uc/gamesdk/UCCallbackListener;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic callback(ILjava/lang/Object;)V
    .locals 0

    check-cast p2, Lorg/json/JSONObject;

    invoke-virtual {p0, p1, p2}, Lcn/uc/gamesdk/UCGameSDK$2;->callback(ILorg/json/JSONObject;)V

    return-void
.end method

.method public callback(ILorg/json/JSONObject;)V
    .locals 2

    packed-switch p1, :pswitch_data_0

    iget-object v0, p0, Lcn/uc/gamesdk/UCGameSDK$2;->a:Lcn/uc/gamesdk/UCCallbackListener;

    const/4 v1, 0x0

    invoke-interface {v0, p1, v1}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    :goto_0
    return-void

    :pswitch_0
    invoke-static {p2}, Lcn/uc/gamesdk/info/OrderInfo;->Create(Lorg/json/JSONObject;)Lcn/uc/gamesdk/info/OrderInfo;

    move-result-object v0

    iget-object v1, p0, Lcn/uc/gamesdk/UCGameSDK$2;->a:Lcn/uc/gamesdk/UCCallbackListener;

    invoke-interface {v1, p1, v0}, Lcn/uc/gamesdk/UCCallbackListener;->callback(ILjava/lang/Object;)V

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
