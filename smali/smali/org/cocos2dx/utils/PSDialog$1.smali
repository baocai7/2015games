.class Lorg/cocos2dx/utils/PSDialog$1;
.super Ljava/lang/Object;
.source "PSDialog.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/utils/PSDialog;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/utils/PSDialog;


# direct methods
.method constructor <init>(Lorg/cocos2dx/utils/PSDialog;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog$1;->this$0:Lorg/cocos2dx/utils/PSDialog;

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$0(Lorg/cocos2dx/utils/PSDialog$1;)Lorg/cocos2dx/utils/PSDialog;
    .locals 1

    .prologue
    .line 36
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog$1;->this$0:Lorg/cocos2dx/utils/PSDialog;

    return-object v0
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 2
    .param p1, "dialog"    # Landroid/content/DialogInterface;
    .param p2, "which"    # I

    .prologue
    .line 39
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog$1;->this$0:Lorg/cocos2dx/utils/PSDialog;

    invoke-static {v0}, Lorg/cocos2dx/utils/PSDialog;->access$0(Lorg/cocos2dx/utils/PSDialog;)I

    move-result v0

    if-eqz v0, :cond_0

    .line 40
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog$1;->this$0:Lorg/cocos2dx/utils/PSDialog;

    invoke-static {v0}, Lorg/cocos2dx/utils/PSDialog;->access$1(Lorg/cocos2dx/utils/PSDialog;)Lorg/cocos2dx/lib/Cocos2dxActivity;

    move-result-object v0

    new-instance v1, Lorg/cocos2dx/utils/PSDialog$1$1;

    invoke-direct {v1, p0, p2}, Lorg/cocos2dx/utils/PSDialog$1$1;-><init>(Lorg/cocos2dx/utils/PSDialog$1;I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 54
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog$1;->this$0:Lorg/cocos2dx/utils/PSDialog;

    invoke-virtual {v0}, Lorg/cocos2dx/utils/PSDialog;->dismiss()V

    .line 55
    return-void
.end method
