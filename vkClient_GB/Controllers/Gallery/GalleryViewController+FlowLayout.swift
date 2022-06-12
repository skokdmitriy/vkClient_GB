//
//  GalleryViewController+FlowLayout.swift
//  VKClient
//
//  Created by Дмитрий Скок on 23.10.2021.
//

import UIKit

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWith = collectionView.bounds.width
        let whiteSpace = CGFloat(1)
        let lineCountCell = CGFloat(2)
        let cellWidth = collectionViewWith / lineCountCell - whiteSpace
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
