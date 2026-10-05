.class Lcom/dygame/open/dayu/DYAlipayHelper$2;
.super Ljava/lang/Object;
.source "DYAlipayHelper.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYAlipayHelper;->pay(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/open/dayu/DYAlipayHelper;


# direct methods
.method constructor <init>(Lcom/dygame/open/dayu/DYAlipayHelper;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/open/dayu/DYAlipayHelper;

    .prologue
    .line 112
    iput-object p1, p0, Lcom/dygame/open/dayu/DYAlipayHelper$2;->this$0:Lcom/dygame/open/dayu/DYAlipayHelper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 2
    .param p1, "dialoginterface"    # Landroid/content/DialogInterface;
    .param p2, "i"    # I

    .prologue
    .line 114
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    .line 115
    return-void
.end method
