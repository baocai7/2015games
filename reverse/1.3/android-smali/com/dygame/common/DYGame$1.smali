.class Lcom/dygame/common/DYGame$1;
.super Landroid/os/Handler;
.source "DYGame.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/common/DYGame;->onCustomLayout()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/common/DYGame;


# direct methods
.method constructor <init>(Lcom/dygame/common/DYGame;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/common/DYGame;

    .prologue
    .line 78
    iput-object p1, p0, Lcom/dygame/common/DYGame$1;->this$0:Lcom/dygame/common/DYGame;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    .line 81
    iget-object v0, p0, Lcom/dygame/common/DYGame$1;->this$0:Lcom/dygame/common/DYGame;

    const-string v1, ""

    invoke-virtual {v0, v1}, Lcom/dygame/common/DYGame;->doHideLoading(Ljava/lang/String;)V

    .line 82
    return-void
.end method
