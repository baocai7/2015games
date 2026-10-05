.class final Lorg/cocos2dx/utils/PSNative$1;
.super Ljava/lang/Object;
.source "PSNative.java"

# interfaces
.implements Lorg/cocos2dx/utils/PSDialog$PSDialogListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/utils/PSNative;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDismiss(Lorg/cocos2dx/utils/PSDialog;)V
    .locals 0
    .param p1, "dialog"    # Lorg/cocos2dx/utils/PSDialog;

    .prologue
    .line 31
    invoke-static {}, Lorg/cocos2dx/utils/PSNative;->showPreAlert()V

    .line 32
    return-void
.end method
