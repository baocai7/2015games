.class Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;
.super Ljava/lang/Object;
.source "Cocos2dxWebViewHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->loadHTMLString(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$encoding:Ljava/lang/String;

.field private final synthetic val$htmlString:Ljava/lang/String;

.field private final synthetic val$index:I

.field private final synthetic val$mimeType:Ljava/lang/String;


# direct methods
.method constructor <init>(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .prologue
    .line 1
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$index:I

    iput-object p2, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$htmlString:Ljava/lang/String;

    iput-object p3, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$mimeType:Ljava/lang/String;

    iput-object p4, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$encoding:Ljava/lang/String;

    .line 141
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 144
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->access$2()Landroid/util/SparseArray;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$index:I

    invoke-virtual {v1, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxWebView;

    .line 145
    .local v0, "webView":Lorg/cocos2dx/lib/Cocos2dxWebView;
    if-eqz v0, :cond_0

    .line 146
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$htmlString:Ljava/lang/String;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$mimeType:Ljava/lang/String;

    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;->val$encoding:Ljava/lang/String;

    invoke-virtual {v0, v1, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxWebView;->loadData(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 148
    :cond_0
    return-void
.end method
